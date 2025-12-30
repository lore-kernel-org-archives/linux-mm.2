Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9D4EE4982
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86CD66B0088; Tue, 30 Dec 2025 11:16:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A0A6B008C; Tue, 30 Dec 2025 11:16:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7265F6B0092; Tue, 30 Dec 2025 11:16:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEFB6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:16:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC94E1A0A8B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:16:11 +0000 (UTC)
X-FDA: 84276639342.05.65C3361
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CEF7A40017
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:16:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cG1OD7UH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767111368; a=rsa-sha256;
	cv=none;
	b=Wbid8tndBMeizJVUbqvf4Es52xniMzqzGY8Dil72Y0gkwyxRXj//1oXsj767dGZ7UkIMkg
	x85GM4SLmVY36dCAeys9syeU602OL6bnO5winsIh2jZuFuID3An6knnxfUwdicV3CXqfqm
	8x22XgfvTukEwl6YtSfAPl5I3jz+xnI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cG1OD7UH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767111368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TX26TM650mDKkRro/fXnbl+XLoQ1USQ4BfmC9rVVJw=;
	b=j6PaJFGdfiv/UlefYkdloyimLIScBNCv4Fq/As7ICnPfZxSIFhR8TL3JAx4iMG+SErNU8z
	GL/g3R4ricymAW9pJMKONuYxXmE0MlD1+/i5b0MhAnpsUNNVDJH/A8YsXVimV9LW+gYFe9
	4dCH/lY2Tv2yMLDbtO6x1z+OTO6xThg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4577405D6;
	Tue, 30 Dec 2025 16:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A5FC4CEFB;
	Tue, 30 Dec 2025 16:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767111367;
	bh=HlcNLtyf8O/u0mMEhZMir3AIamz/dUTwsMWTaLGExRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cG1OD7UHqRWnRx0c3h5AWJz/OZ1xiYrNSHTEElBM2TXQmtHr7iXURNccCaodth9rG
	 5xiCAPvXL10s98nPJB76VFOlqFQTDARqp0lgbAbcfHwEx6nz0akAxOV+TAiNP3eyUK
	 in6KMbJe/REScuCQ2skG7shtIuHzorsMdmbi64HmatTw+SlSFYP/UDLQCL4ittiUNA
	 Zq60DhS0GLjGM8Vv21SwVWzC3p8hVztq+yqkrniB/3rvAtg0uimL+/HUuMsXRavNYf
	 R3qWNUI/KAimLiCv2xu+h7K0m92N5pDO8TosTzLnzw6QN9AeTo3W0+g+3YzfYn5C4v
	 QElwDP1hpWUJg==
Date: Tue, 30 Dec 2025 18:16:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aVP6wBYoHJQsplIl@kernel.org>
References: <aUUYprAotKYMiEs0@kernel.org>
 <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org>
 <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org>
 <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org>
 <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org>
 <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
X-Rspamd-Queue-Id: CEF7A40017
X-Rspamd-Server: rspam03
X-Stat-Signature: bp1k46fjfamunoshw8xtz9gfbihoruk1
X-Rspam-User: 
X-HE-Tag: 1767111368-289220
X-HE-Meta: U2FsdGVkX19W4APNeVFb1vEkJv08R00f23Wns7rtLzSB72z7DWUpn0zGcixZOceOs8x/TvDJ1zowSddTTtR+NaGDvueQ3aGrSk38kqyycw8Id3S8q11P2vy1vGXnOiItsw3vU0eJOH35l0Hp5oaAa1EG+z+Hz+pUbxslxnuA1QodffiIQoEKxAP5wLenYT8suPNO+JBzwN2Ey4Sw2pYlXN1SiwKAeT5lbxl5cQrc6u3jJ+8cnfKbGksnet9DWmzbxh+mfi4wazLILL/J6MwewMN97ONb9HTG+yEJMt99o29w6QEsc/SXNC3kOnpwpJ72KBZaHa6vA+fA3JlmO5dRZXdOOWhm+opWiEmJ26pCX6//gKeE/sy5jGjlt44aMnRaJo7xzqE3ljXdzZnKnLC3OZNUFPWaooOtBcSSTcPMSVKwIYxs08qCdNiK6uHm/7VrNLsMOu1e+eIKTG6z6CLE1PZcai9s4uEUpxHS6j2mW1BCvIt71i2ZaWZAA5xSexxCCaFbwWcaFxlAyFAHEQ08KvzjxvJf61lv+c157WfVVCjkyDj0FCFDbXBVMp1eETvSZWjQhkXyL1cwUaXigGg8a7qHfh5y5iMBS573oYSSfGj2tJ6LAUo+0vd7jWEBIaYkp1OILrkimv8pgUxTsyIBeMAtFlsVckC9Kd0UZBlkI2pR2pZHW77AY2eNQtMzFNsEVThTFB4amVQDMCezANc0BKwHC7QL6ASCxSib1KIgAGsrUtZfOzHOblkdJ8BTy2DmpzmtY4wTgaNaWM8OivpcJVLLszDHt1iF9IL4HdVlMMtnvv8Ty4im0uscuy90p+2R/bYs8RPzkAxJecwmtIRemb9BPCLpwKWdXawq6XsoHBUTLq5HjCYTo8EUE0G/BuG3Lyrfj+B9ukd6qP/VkwGZ8lBK4melsjxHjVm5KdcFbZw9vGVpiHEDtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:05:05AM -0500, Pasha Tatashin wrote:
> On Mon, Dec 29, 2025 at 4:03 PM Pratyush Yadav <pratyush@kernel.org> wrote:
> >
> > The magic is purely sanity checking. It is not used to decide anything
> > other than to make sure this is actually a KHO page. I don't intend to
> > change that. My point is, if we make sure the KHO pages are properly
> > initialized during MM init, then restoring can actually be a very cheap
> > operation, where you only do the sanity checking. You can even put the
> > magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
> > it is useful enough to keep in production systems too.
> 
> It is part of a critical hotpath during blackout, should really be
> behind CONFIG_KEXEC_HANDOVER_DEBUG

Do you have the numbers? ;-)

-- 
Sincerely yours,
Mike.

