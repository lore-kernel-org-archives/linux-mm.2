Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A641CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 06:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0C46B0088; Fri,  2 Oct 2026 02:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FCA6B008A; Fri,  2 Oct 2026 02:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31D46B008C; Fri,  2 Oct 2026 02:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 737066B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:01:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACA618065B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:01:36 +0000 (UTC)
X-FDA: 85276639392.20.B9B517D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD83C180008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:01:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=abZnHDcS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790920894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
	b=FsWpVn3bHlI5cisKibNHQKU7SkmEDzmofW49Ehf6c8YtOgcxRtZuRrLxHIVlYo4xFFFKXL
	PKM7UikFfBZUeWOVUWn+pJVJmXr0knonNtfTu9i081swd+1IolgmVnzNpmfEJIMXbCIl1n
	ake4ZvHUwpceQUMhDj7xchxkYmWr7QY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=abZnHDcS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790920894;
	b=2iV3xRmz3m74tXx0J2jOqdQuYPdD09CqH6qofHc8kACXwGt5o98XUgS10uuB/DwTnNfT8x
	y1Ssr/pv8Bz4sMmS3NtzPdE8WavvD0lHTQxH8o50JQPKjHst94tAb/k57Kykk1ygmQklex
	WEvwJCp750+Q2MubdhWQR/6g0SvNoAQ=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2dfa54c8ccfso5684795ad.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 23:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790920893; x=1791525693; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
        b=abZnHDcSh17Y2erL313M5xfqRkyFj3G/fQ4RNu9gHDdIQeqmEdWcO8iG7pU5c7K71G
         OOB94LIh3ZkHWxyOEaPyFJ2b5VELn7yCb3QBft6R1i4yrER2fZbcugRSMOvCfOxxlY1h
         dvPLuX2PIfFZcWaxoidNRnThgnBz6L+HYfD+MEmclVk8tD+PqmAJk5CgrOUejFIECPkC
         1cNdA9jWyJ2PIYxOta9QSqRnXM2CtxvvDXiEOcRmmdc+zwwRfx90q2+Awdeilr05+vkw
         a29wHnZp7EeIId4zFDwc+Zm8/a1/zCm5X7koZAYwp3mEae0fpQnV19xdhisNptojBx+r
         Nfvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790920893; x=1791525693;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvzqwuTjdPy91zWm37KIYjrvoEq9pY5JTP911vnp5Bg=;
        b=vG/0VL3mR8dxG+UdCgRzplrkmzjYVP7vT1EKPY6hGJ89jD9fRSjERhQoseiYxdqVDc
         SDyWiLSOwATvF1sKQS+q3Y4BQ4y4tMyIHnQUbG3YIwWdavIkp/N58ad4gOkU9xO6Ag4E
         a1Cb8H4iwx89j5el2Mq6eH0MsZl2ZF1lQsf0ne4mhvWEU0Lq5ZH7dpePRY/PgLoiBb0g
         0CFH9fCCZRekTVCp61KlPDr6ogbKIJFZ02lJUp7BIegWBxBa6ITxo9mFvN9Yj+5FffQW
         rfab8wVL+AiFWCSQEcBZMNUVDapqTPaZAPCARZH6JLraaaC6m7xeBE5a9IzPMasShTnH
         SXYQ==
X-Forwarded-Encrypted: i=1; AKwUvByPIhTtKrOWFAtCC8f0RSJ9w1Kcm1Q+VCz57NBKTr/MAf5TlCHjHH+uzlQJZjI5C87eFpZoOYgbaw==@kvack.org
X-Gm-Message-State: AFq9FYJBgyf3EPa+IMD1dvmgVpVnN557/kwOH5G23tlkaiIW1Cwr+XnR
	wfb8Sv2J2NsrIp3eJ2hqNXXQQ7kkstzQwDNQeMw1K6zqsT0z08xQPmU2
X-Gm-Gg: AYBFou3JZ4NLkOhnFTcFRBPqpmsUHojufm0IviGIVEOZsO3cAlh2UDSJYIHGSstxydj
	f/e5bJzNjGmtmDclkbtUQm0NeQgi+zdeUa5jyapKbT2mTByN1hVjRwD10O45OS9Ldt0awScwbKA
	9ImPlcWua7fL0iQmwmRTJxtDVjHSInvxW9iXkrhy0T3wOj2pCRq1MeMCjQllHYj8EkdoQWFe2YX
	lY/5i4XR8OA2qaJGBS0UM+7M7EdUwuPrmX9z1SLAVejjxls6E8MZNgRBpMPMF6WdwWplk96BsNV
	w4uxdlp2PzFDyHBEPhkP42xP57/c9BIcySzAC2iuVLqyAoZLcUm8+8oR7Zw3PNI+li4ZVN+CXjZ
	uz+UWlppra5QHnE4KWfKvdeXpOAytFduCID3zgHFyRN72aCr2eZinlpqpSuNTKM/mPxWsUUBE2d
	Zlt8cNvOhz/Bof4iO2CCWxYViDUbH/tfTw3W9ygVVXecQ2ZB2htuNa6WMUS/oh
X-Received: by 2002:a17:90b:2644:b0:3a0:f2e1:8af9 with SMTP id 98e67ed59e1d1-3a4f3d124f2mr3588321a91.52.1790920893294;
        Thu, 01 Oct 2026 23:01:33 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc9f721a6afsm519169a12.0.2026.10.01.23.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 23:01:32 -0700 (PDT)
Date: Fri, 2 Oct 2026 15:01:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu, linux-mm@kvack.org, ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
Message-ID: <ar9IuknaJqrGoF-j@hyunchul-PC02>
References: <20260929034158.1455429-1-neilb@ownmail.net>
 <20260929034158.1455429-2-neilb@ownmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929034158.1455429-2-neilb@ownmail.net>
X-Rspam-User: 
X-Stat-Signature: tgfj5gnu5su4usyr4pmyufrkzrmej15i
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD83C180008
X-HE-Tag: 1790920894-491734
X-HE-Meta: U2FsdGVkX19LF3iiV5iAtiYXHyweLIB2rxdFETxAIYF3f1XrRAhpQvtdjHDJbTtowjFdcK49QFbtc76u6vBU85+Ct5LkvIRxeFHHU6mFM4ymrfU/RSoMxkQAR1HuKP2uDc9MgHudepYYZkbJgi9QVjrw+GY0O3Bv3UmOtfjEul8CLPLZAl4TsmGhUC+ndHotq/+aijfu7f4laIp+hbVvWYdBnkUObia9EzFh5Bs/DpUvI/iDOHIZwL6gfV56lg8P80e2Q8IdnjZ9fF/cocp5VZhyeOmgUI9pJY4FEGO7a8ZCNTZ6iOu9Nm4LfWmGJUlhyC7tq/t2UKdxhDopnkSuxCqSgKZkeQAPcE5DeQXZXtGVCqi3Th9IGTtyYHeJidzRkIdD0qjCKk5faq0afc+7y8ChVYqNpC35LABsdIe8tscdjMcnMoMX0SyQI65TAf7kcAfaFJRhDauNMzLaO9aqOsxKo4JJmXGcH6GXdhkdY7ordqxXzmUKDT2sLG84IbL2MfrJKCVBw6MuL0hoqsGogFfToT3Wu+cfKAJeSGxkIH4Rc2xb5OWsKM/vJwwh0lGIQ9ip3CiVFUKOQDumjCwD9cio/QdsFEn8wqF7aj6j1X4U+LW2urZufLAUvW7ItvoGr7qGlw8km+qZIBxK0VwOgJpYXZg5nTDShExR4ZnuBcjTbydhRuCS0ePrLTC/l0Rm3kezhntCv7/hGuLMfIuNHv2CsdJlRn2g8F//RRr+n4Hp9DRTzFCWpfqXP/FrfAUzaVbJR5Y4WOSi19nbbKMY7kl34mTM8YkB47CSuF+xQr3Q6BdVtiXHBN5zJJpMzqH0+pwt1dJGm3Vj6WoggwD8JWS2czLi1mLy+85le213TC7YriLehfXcTcLXrg+GkT3FvKzW+1JiQmemYlCbyTQD3hBCkrDQUyWKlvUU7XDEaFVvDKAVq/DBTRMdTHX9FmSB1+a0fApFwxOtXChdg5i
 QUkaxfyF
 puRqW/wouJmgEtTMqR04SyIpQDn8lZmMd8C+E0Kb4jUqlvubH05xM3U8bbmEgmgSxpwYZv8LRIsz5siDEgEr94pWhozkHjarLUs8tRBF7z3F0bo35e7USS9d3x8ecNx1wGQo/ky5mxiE6p2LNoR1OzK9sNWiK66Dibj2OoQSCu4hApHbbdJQKWlnW198dzC7olhYAljiavBTKnZ9jWhcAnQaKGD73Jh23ArVbSMjEsa/qdThPivXzPCFDnk1b+mlV6/HMY3PuxiJQ53kbk1QGpz7YHex5c3iRJCLp68q09gojSioW1HFrI6QliRlXIDJVC1uzeWIC3vgCgsMfWj9l5WlWnGm0WZ8HaZsULHxyUNynyA03T5yq3T9PqbbK9W/Ry4cwDPl0KSqg3+jW/LVKI2KM+3k9PXN7F/bK2+JlYmb97RDRz2xOOnzKiX0erJgGq7WKs1/jdwgDpFMgFBJoXibk7Yzll+k8V+gAXcHp2DNosobqH5TEqjXEzRjsGALD3HfivWoCIOYBda+CTFE1rAPqKl8wtUCACHMg1gsK8f8/jakEvNgTJIApc6fk2PiTVAY8rciRmMNrIKOF8D5ML0U5seL3BUbJPceX2hcy8ONQb2TxIN497jGsrc/AvxNLIa4wAybWnne4c7We15pSjf/P/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 01:36:01PM +1000, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> A proposed change will invert the lock ordering between
> d_alloc_parallel() and inode_lock() on the parent.
> When that happens it will not be safe to call d_alloc_parallel() while
> holding the parent lock - even shared.
> 
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.
> 
> So drop and reclaim the lock (shared or exclusive as determined by
> LOOKUP_SHARED) to avoid future deadlock.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

For the NTFS part,

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul

