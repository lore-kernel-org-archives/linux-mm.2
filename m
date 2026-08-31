Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544FFC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569CB6B008C; Mon, 31 Aug 2026 19:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543396B0092; Mon, 31 Aug 2026 19:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480FA6B0096; Mon, 31 Aug 2026 19:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8AC6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:32:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDF16140280
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:32:13 +0000 (UTC)
X-FDA: 85163165346.30.84237B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B313C000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:32:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hM9ggej7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788219132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqSnM2Sf1MnAraFVDX5f+6TBqIzKd36nKm4xtyvhybM=;
	b=Pw/HLyWg2WehX44o399ORcwIL+ImpLplPKkpqPDkDtOq7knytC3zs/YkC8xs/xIpCyfs0A
	DlQIdxVHL4PSuJ+9lnVaaxV1Nrv0uyPAIPUFEZ6w183nYxNT4OYEG5mkayJ+eI8yR5hJoZ
	FKeH4kFf2ATaj2Yb6xQB9BMIlyhit0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788219132;
	b=wDgW8OZdALh2uq2u+x0+cn2ZPll2hgwrrHqzGhkX7eH34zAdFvpoGRItl/3SygX/vIKPU0
	PwPmpWi114VyK5bF2jaqJXNen+XEd5a2do5rXwFLeXXMm7PpczWW0i5DodwG/1n4s6CWBu
	Tpc5OmX2s8qrJ2hFB3k4yoIrsnoO+HE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hM9ggej7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EC2640496
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349431F00ADF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788219131;
	bh=HqSnM2Sf1MnAraFVDX5f+6TBqIzKd36nKm4xtyvhybM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hM9ggej7PlPuTMCDzgOh3zYet3jaCTTtvglzC/zYWOZL6KGj0BcKod4DB2KHZmpuk
	 9Xr8E5fI7omKEWAg8npO64Q4oxaIsgjG+ROJho52pGDM0t6/3xak1DlwmCvfeLGEq2
	 QgA1Yt5/MRFPTMRaDIUjwW5YGSiC2DurJZI45p7kp3NGtY4Qjnfuwky7WXn7o9f4Z8
	 wC4Ds6R9vHRh9IGZpDif5s6pgETlC/Wre846fOo21aTGBy8Pvwtz0uK2tMm6Oadwv/
	 53QRlUMvhrjqA91WlLKbIal6dENP3blXPeG/7/rBm3eOLTTcQXLTrHKYGeIJ/eD/kO
	 gZhLRtPK2lJyg==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a668ce86abso1093445a12.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:32:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzYtfmykuc2FmaCHHt1Hc4nnMtca020pFeRGIOTmiUH3nFbU/HYpAH28rbGdaW+mAafoBDmag5w3w==@kvack.org
X-Gm-Message-State: AFuF++lBII/PQjtvXZPNyM1EJlK3qwcM1ismGhFYEgzf++lHbX35Va/E
	I+0kjVQ2TPQZ6pr59phNPDpI/L+caE5fD+4Ftx8BucEv75YucGExdl/lGYpTFNYOaI4648PZPKO
	QBgDQlwnPp6vZwW4MpBFVBzYBSf2VmWw=
X-Received: by 2002:a05:6402:1e90:b0:6a6:32f5:90b3 with SMTP id
 4fb4d7f45d1cf-6a663b24942mr2593080a12.21.1788219129658; Mon, 31 Aug 2026
 16:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260830041901.2668-1-willy@infradead.org> <20260830041901.2668-7-willy@infradead.org>
In-Reply-To: <20260830041901.2668-7-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Sep 2026 08:31:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_zarKuogwNS=ZNDuyR4w_iB7yui+h+CqGvjZvzxPFpzw@mail.gmail.com>
X-Gm-Features: AcwNN1UvF-7AQZoHjsPGrrmMkPeyVFXaEcU2n-gcV41YpQO_AYBnZepzQZ06-b8
Message-ID: <CAKYAXd_zarKuogwNS=ZNDuyR4w_iB7yui+h+CqGvjZvzxPFpzw@mail.gmail.com>
Subject: Re: [PATCH 6/9] ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B313C000B
X-Stat-Signature: tmw83agrsx8rjrd875ycf5fqsqrhrxnw
X-Rspam-User: 
X-HE-Tag: 1788219131-29131
X-HE-Meta: U2FsdGVkX1+5PqDHDus4XExuWtRm7TZ/KczKOHi6LbOYzJaMvu4X3YCTeo9qLwk3tipBRiIm1DaeZxwahgAUCBx+95HQy+UbuMTtMXb6OHVjbyJSMODDr23Ahg0tlvBOafluAnP8dObaAOugD2VJ9DKGUV2DccO+MI1W8RmpU8EbAa9vpHTL2owxwbWBH6e0PCc7Ac7iKi3Pv5xIBooE+yLcO4oQpEuQTx/ebGlBSwdeDzezjXqJmDKxFJildBBFF6bFNkFwD7QL4iOnovQ2Gdop1LB5GHVzeZKGA5Phzfp1GbDfaBGHL+RgMpKfTPm+c+W73XjDxabbZ7d925Qp9fJAzJZEPPFlpxuPn5+y2I575uWP85Jt7Eeo+FEwXhiw0eZBm6imXCdc4MJQHD2MoQfsC808ouK5t60UFYe+Zm6hoqDFhEVF1lPAttLFcaGVA6CH1NvJ1obiCv1XhhgYts1G2F5EZzfLOy6I6C2ujuaAvo77c2rxuG9slLfCUkY+pGu3GGtCaCyYsS3qTkCXTooclMaFAZI9WDHnQBom3ehw/0I2OzsuQNLpcGoYZWKLkNUvIsAw3cIBwTC6UbJJwhMGP9CoDapw2gFlxAATinzRiAXqSGYuhloMukhQfi7IbpszyWCvk9mXJrwXprb3Fn6YmiH9QvIoftJB5jfB77/uw3y/UCpEGK9UVRuDbaNNvgv8fGANnEZDJ2cl3dQh8xsRBt6jB8UpKUxwt+I51+C610CSBFeT04y/LjI0e1M5fFBDCngceSvb8rAE8kmP4We/jONy876jYxUi+T5yMND/NH0WnAn97OYk2EibLonq5o34vswDPfJ7qyOTqwJwDhrnh4sXxDC+DkK1NBXXv9a0ytuTgYv6mkfcoXGqrctCO9PAi9RWE2SBcdvXnG5QnOt7N5+tcXaO0KY++7pOMboVadH6SIVUXXQ4CQN2XjG5N8HmUFhGfVBHIpyUHm4
 HUuv+4rt
 le6KVc/ahwvM7G6R+p4RumKhFVp/rGpkBdHSE6bXZCZCHt6uscClBDLQsBs8aKkNZRy7/RpGEyYWOWfpKNl/5AfGHP4ZSph8CCNmR5yzk4XtzPmoeU1JR/iDaej/9bTu7EVZCBXRw5Fknp/QI6RbG8rR6cN/PoPCrGHC8FR9D6m7hbQgMc6agAXF6Av9r3WBaE6Y7fAwDqwmRzomJMka0KDlVYLFI5fb/JEQKBB2rHt5JU9TpKkixaEMtVa7NWNfUewe3BDXXJWmQ6eCjlzo/pPqJI7hQ7SMk75nYV350Qc7zLl7W/wqOhU4sh4driWVdHUge9PobUOmdZVYKioxOnutTOqd1QPOzesbSTsRkeJZd5bFr1BhVKtLXBSHdWF5piSX+vdmqELxXw8bAYOMwjHjmdBiDtzTWFf2wKEWxrHTbcIQ6tSEBgSMBiNzGAYjF176T4Cb/9rnKUeiN9Jywcuvp8XMBltG0TpTPvYLJI8wveMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 1:19=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.  Use mapping_gfp_mask() instead of
> GFP_NOFS as this will preserve flags like GFP_MOVABLE.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

