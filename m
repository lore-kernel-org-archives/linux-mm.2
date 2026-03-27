Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA27310F285E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91E56B008C; Fri, 27 Mar 2026 13:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BBA6B0095; Fri, 27 Mar 2026 13:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2D96B0096; Fri, 27 Mar 2026 13:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA96E6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:37:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81CD0E17C8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:37:06 +0000 (UTC)
X-FDA: 84592548852.19.7BE4C09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D258810000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:37:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ltMB+8JM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774633024; a=rsa-sha256;
	cv=none;
	b=CTxp9/Mfq1IgPOedIFeibbgl+MomGONd9EJ50q97YZ9vp6xa5c+hppHF4ShkELtoENDAdZ
	23sUxJjR9DKG+oOtJld2QAxM7jBEj1ahX+JARIGCxmgGgUUeFxEoJrgOcZQUAGtyJ3/ep3
	NLiOYYtti2Jgsv0PM+vl4iv83s2Eglo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ltMB+8JM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774633024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjbVszfk5H0B4FMQ+oBG1kCyJ2Mm1XRJcJft2Can3OE=;
	b=MhwHNSMQhT7TLbfagD2chgB1T/iQYg20NE5K0lcuwDmfeKGFpbIoPjcODFBAtvmwuYhfTh
	m/YUeRf9YLr0H3Gbmkm6yVWVNuczRUmqeRf8tGcc3eSG2e7zcSUvMP03fe18vrQJ7LIdBn
	chefkkeBDzDvGCajmKUu75hNdnxTnss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DECE600AE;
	Fri, 27 Mar 2026 17:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5743DC19424;
	Fri, 27 Mar 2026 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774633023;
	bh=qjbVszfk5H0B4FMQ+oBG1kCyJ2Mm1XRJcJft2Can3OE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ltMB+8JMKlPEXIY+iIffEuXUD808lFlKdG9/t8DDuX0N0gSKM2YjihjUaPimovERF
	 nONpobPbdpl1PNuDk7eWBuDiZuCBgL7jiX1dh0NOWE4sxMlAVvIXTrQ9rW57zK9dPr
	 gPFB0fWqjJ6aQujfaZXbKSmqImEHgvcmo5w7aKr794x1Of9QkaASPEInq4ggaixK3F
	 +ITlFC4rXBuG5I83mFhZQcA3KPGihyZQyj6vqfjt+MyFHxzhhFqSK89Z15LiwM6mHF
	 nTrt+qNaLoz/uftVzl17mVVVTodB57d8SFUettkdWl1gRWWGNnkDz+BDwpWKIq+CFU
	 w8w+9j5eLaqqg==
Date: Fri, 27 Mar 2026 17:37:01 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
Message-ID: <df0c2fc2-467a-4ffb-a697-7c89d64bad6b@lucifer.local>
References: <20260326080836.695207-1-surenb@google.com>
 <20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
 <20260327100322.b539f1a9f3662a0a4c080cce@linux-foundation.org>
 <CAJuCfpFxZsnZqqfoKXX=JEBrBaqZHNAgBE0VHbTc=GhQzP7X=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFxZsnZqqfoKXX=JEBrBaqZHNAgBE0VHbTc=GhQzP7X=g@mail.gmail.com>
X-Stat-Signature: sej9s3b4sj1r3n17rf478egw8p3456pi
X-Rspamd-Queue-Id: D258810000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774633024-521945
X-HE-Meta: U2FsdGVkX1/1uUFNcGJYfgpjpptQ6RA76MZ+p88UrSAVaQh1YOE2TkJaKsaW+al6YeZe45KUQb8fbqqIiyZqJy3nlhvPIhAilkYuxDGjR2b8zd3fIXKSiamJqHXh3tNAeJjmeukFzaXUO/1w6qsPGkj4J3J1zr9Se4j4qVkDh4C0eNvqvNQ6wmR7PjMsyjuxKcAhdfI2bQAFEUexGTG8lkxQUJiY9Gnhwi/HnQxYHcXNE0VTgdW+n07LDmT+ljXnpneRGACl5uHsk5RbmXexcsC/FNIG/ufxFItoAO730YWUAc8USLripz1+b2c7jUZuyh1+YcbRwao6AXXPBHAkveWe8O3K5gY8FES6JnVPyiXY7xdeuZ6o5y3QeoH11iSWjCds8WFzPY0jPb+WyV8INU4HEOMhqytIUK86a132C/oUo+Oiuh9T8iPQgEvIepT/KQcSN/jupolV+Sd6rob2+mtcrLfQEvScagEevVPWCTN507UOtFwyQz+Xbx7qDPZFLdPDNV4AaZ+ACfVnC9Rhyb4zxafczt5ykh/qwuZbJKLBHl3fpABklMg3gLGpXnNB6Nvnp0+s/2Et9b8IJEhK+Qyg3bwZCkm0JSp0zVCaSlT7YE+WBuABngwN7WI49k20226qmo3bSh80i0W4VHXVYTri+cOdCoatUen+Wk7ZzzxH6IWTl+R9Uv6h+I7PhWFNskoPE6xFXbag24YpSc5910z/jqnsA26/51plfWiWa9wHkHVhzm2EGwvysXqqhUTmZzVEc99xyDCfKZVBHryw7aOYVc8KJ6SaMXsINe7g3tcPudAVzSu14kLsK+62Z0cRVa9GgAZgd4dEo4NPgumak+6rYYX/DZ53reeRlQrI5Nc0CoHMUFgFHMhW2TX+tM0ATWkb99wzVEFXx+t8+Ery4C/F9H1e+kxvDbKx2UtIfzzMyIj84y964k91VWMIIRYGXRXwJjaP+YtWERpiSKL
 4YNbtTGb
 GhUBgD5EFXwjTN2NxfI0eodC9A64bTYUJGAVOiySgKdnKdsrJQ4atMyFB/JfX39n3Ks0GmmGbzdISk4gRq0vFozL8cqyY0ht/NiqC/zQdphwNa05qzeWnM0s47/8hLW3zp4agcLoPoee8T8XqG1AKlrLJ4KZKjz2Eq0CqgCOFAI1neSSHfM3vJx+0O62Kd0X5c9YC2+vZ+Ln1DK/URma0ucNwituAnc/p822BW0iVxVw+hgYxaf6IYyt1utJp7LarPNzerlYrmRpzKVdOFrGv/d8nNDbrMq3vI69Ze7EjKS0i/fjXRy9Qgv1ChwsnjwOe4fvc/7DXiBnEQW8btHB5U1pK8gFaU5lTU1+hPrvFO77ot2ONwr5CdJirJmbJgvRvbLCQy/US/IwVvvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:32:27AM -0700, Suren Baghdasaryan wrote:
> On Fri, Mar 27, 2026 at 10:03 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 27 Mar 2026 09:47:38 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > Three of your patches lack review tags so now it's 65!
> >
> > Three is now zero, thanks Lorenzo.
>
> I just finished fixups for issues Sashiko flagged. They are pretty
> small but important. Testing them right now and running Sashiko
> locally. Once done I'll post v6 and will ask Lorenzo to re-review
> those specific changes. Sorry Lorenzo, I'll point out the specific
> changes I had to make and will try to make it easy for you.

No worries :)

Could you send to ljs@kernel.org on the respin? Sorry to nag about it but my
email more and more set up for that and makes my life a wee bit easier :>)

> Thanks,
> Suren.

Cheers, Lorenzo

