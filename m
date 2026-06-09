Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 916F3CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033916B0096; Tue,  9 Jun 2026 10:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26896B0098; Tue,  9 Jun 2026 10:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15936B009E; Tue,  9 Jun 2026 10:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D107F6B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:28:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93A9E1405C4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:28:33 +0000 (UTC)
X-FDA: 84860604906.01.121ECED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6C0FA0016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:28:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nxvUtw12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aa2gR31Z+8UFx2QrssjKKZ0Vpf6BD+KhrKV/ts3/hy4=;
	b=mkfoyNuoqlGPrCtjZwBoir3AuTh4tL5SWb2FEk5YCwW+0ilO1TC/phq3CV0MjUqOgv/CKi
	Y8/HoFCYKFcKeheXU8RtnxZJPZxrWsygUzCLRAxDi0bn+QoMpn9Xy/kQEY0GDdr48fu9Yk
	ziQWkqEFbOWfdb0H9jQarBABd8tRXj0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nxvUtw12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015312;
	b=lun7MplFYnJwhxyF6vSIg8zrIFILdOxFuRG95SUhrQNbTGJNpbgZ52cH0k41FyYJkH3zQH
	yYBImRZapnUQlaAeVwkKlwfuLMATt/zkBQYlMHFM9n8i1gXsAXPG+a2lmJO5FQWJgHRxVQ
	A0anQQ71q98FbDdXFMf0pMRQ8ZdGS8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3929140401;
	Tue,  9 Jun 2026 14:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C9B1F00893;
	Tue,  9 Jun 2026 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015311;
	bh=aa2gR31Z+8UFx2QrssjKKZ0Vpf6BD+KhrKV/ts3/hy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxvUtw12BzdowvW6doCOqJdXcqyuVIacRLC4e7BndyxqZ+McgcwfO4iU0KIK3BO0A
	 yEKD11yhv/rVzzKGKg5Rt32vbh2VDCLCFII0WSE8hKgloU6/3+cPAWQpPX+4SOoZxv
	 FxbJVT6foUrvVMnpuY/1BSaa9Ab9r0J/5MAgp885qLHSpFWOKGxXSKzQI5b86H+gGV
	 FwfugoaaqvH3BwgEe522Ih0ipMDOnb22CAMFivk/+6TD1OrYDuaPTytoIiXw90Th+C
	 w8ji26r27NRIPm7n97Icko9yQL4yB6aUWSWY7d5I2Gpr7Km3DUfR9NOC2PL/bL59eY
	 ULCPm9GMIFQnw==
From: SeongJae Park <sj@kernel.org>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] Docs/damon: add TLB flush policy document
Date: Tue,  9 Jun 2026 07:28:21 -0700
Message-ID: <20260609142823.68951-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAN_Opa8sqs-V-jFrGZa6jwJKdHqT=7JPeLKcU8E-cCM74ON4DA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zg7j1qm49tqphx9d9cxqex9kxjz16qkt
X-Rspamd-Queue-Id: E6C0FA0016
X-HE-Tag: 1781015311-228138
X-HE-Meta: U2FsdGVkX19DqTup99ygVB0XyMiqCzzwkTjruw4aFTfkC1lz0qy8L/auMKHBJjn+/1zmZu9BNjS80/9Q5fjpXhfb/s/YLDJQd83O/WMF1MsSRbuzaqZutg/V4rU2Ny/Isahj+YHxiWHEl6jIJ2sCdAVgp3CUp7zuSNpi36SlmriqzqVBZ76nwMIGZs7aUr/85mWCJ147kYLaXlS55U/rNcuKhnbvfnwJtOzQpoUqp9rVN7sFUsjxUJ/CB/hLhuY5rDCh9bmmLsctfA33Mzs6eJv1o6RT8Tm5P20m8stH9oQTrv5ebkt1KdJERM3vMG7LehAXKN0l/hk5SppS8qaNeeXuUsdiZNgPkgOKGQ1PPOiwTUJnuOqPHpMEpo4YuYObA0xfEUrqRy5qGWTeX00NyGUjUwrhv9KPwVuJ432yNTj/CYUyXFyH+/VCYvs/2YcxWokAlepbxREh+LNBPl5zESNIQqJuzDrv9gtY9vVTnKbIxzDVW0mesJkH6HdJwKdZ+hLCME9YVhRLXZ9zUvjdoWXDXZ3O8arMIRNfIRUm4NoJXllqoT0Yd+Jv92qtN+djuCbDvjbEDBJpa/8U66+Z0bfT20K3Ezcads/vsNkpY25QRldugqsuUgIXlMQ76TDXpYtVylRBpgdxf0tE+OarVuY15w8l7EQe1MMuS21ZopzB84cE08PUjKRY0TIadHMhGMl7LDjHTVsKuSfKDqFz0yo68OIDsWWoQu3guLQmUZOWGHPofCA+iNhDZXORmTGJsvm/1h8JG8oJW71CrFMLtUPfpyGfJqxfICiM/zY4+XmYCZqRciMHv9zMtvlQ0M6pQ/eGxnP2L9yeJ3TjXQoUeersdev6Q8u/oC97vH2it4EzrKT+i2lr7AyCLi/MSRIGBNuoqf5ohXifia4Cnn+5BDxRzJbIkCVxOC6J3hJl6u3PhjsTXZHhui0e3EAyclo+QjxtFCUvgNRYHS2cKIv
 970t8NsJ
 UmlD1dxSRaAkJbOaX0mQPym23CX0I3wPeSXmy4pbmk1JlVztKdZsPFR+EDB2G/IQUWaANIxFMekNXM+tA17nt5ATjkYr+gGfs4bp8aRVjMt1uAFe4fqAL1y3k6SOJiOaGDAhZnH/BcT5mb/ARjNBCOl70+Q9+SJfKiBp0A16Y4+Jlw2wawlaZAUHlR2cHYvfokN/YkqDz5bUNxJ41Kqr5gWPvLuYp++p7+Tf9M/K30hCrqASdvQTqDuXHDYyrhpS6tB/d95aK27RZaCghBmHP1pmT6nBlPYOIjcDAkIAQ0h0+bie7HhJMmDZjU4atdBmqF8kkJCfbgvVIN44eMmPbI0/sTWg12nPssflfiRwULMoHa/TLFw+y4941f3JTrgMJyUB/D+t0repCD83tYA+bPN+c+s64xlxpCNwg0gJP6sNg5C56xclQjZH8BK3d2KJQWP7fKyS4slJqMBATubI8ZUKumCiHOhr61XiKB73v4rQAPOgD2fBODa3wAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 16:11:30 +0800 KunWu Chan <kunwu.chan@gmail.com> wrote:

> On Sat, Jun 6, 2026 at 8:54 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hi Kunwu and Lian,
> >
> > On Fri,  5 Jun 2026 11:10:08 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:
[...]
> > Mainly due to the verbosity, as I above mentionedd, I'm not sure if the current
> > shape of this patch is the best to be merged as is.  I also find the background
> > part of the document is a kind of duplicate of some information in design.rst.
> > What about putting only essential information in a condensed way on the
> > design.rst?
> >
> Thanks, SJ. I agree — this document reads more like an article than short docs.
> 
> I'll follow your suggestion and submit it as a blog post to the DAMON
> project blog instead.
> 
> Will send a PR to [2] soon. Thanks for the clear guidance.

Sounds good, looking forward to the PR!

> 
> > [1] https://damonitor.github.io/site_about
> > [2] https://github.com/damonitor/damonitor.github.io/tree/master/blog_src


Thanks,
SJ

[...]

