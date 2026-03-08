Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F61DF55138
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 09:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13926B0005; Sun,  8 Mar 2026 05:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96C66B0089; Sun,  8 Mar 2026 05:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95D66B008A; Sun,  8 Mar 2026 05:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B890D6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 05:19:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27C5C13ABEF
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 09:19:33 +0000 (UTC)
X-FDA: 84522347826.25.CB92B87
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D18D180002
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 09:19:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eTFdUvKF;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772961571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qYzgh6uAd/1Nf5hmJK0kVF7yvFRbMy5kDQaFgFAuQVo=;
	b=yJz7QDPZV7hWEOSqc41WmsyNZ7GWD1QZPSIAnTl3/6hCslG5zInaruwDFFh+raLr1nJmtZ
	52zsJKS8ut6RWCBrNuVNU08Y2ZPqCVTs4gW6bPVXo1zEIEWi+43X+IYZZTBg6W/BK40sxP
	+4LpXIkwDi6r3UbHDQln8nXu08bBJos=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eTFdUvKF;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772961571; a=rsa-sha256;
	cv=none;
	b=I1lBHHVfuZM8mbOq8Z2U//1bvrQBpU94Z0S2+SlbjJ1TXvV0Up/47f8/ItPvtPfCfPg7in
	cYFGwVoBaS4p6koBvKpxThtwzmutsAUG2skQQKfBtr4mK2PHrWu6nYyYSsXUGAxJGhfBCp
	m3jQHP1D3bOerK1HjcoaWlKQwjdWtb4=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82984c077b2so1529238b3a.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 01:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772961570; x=1773566370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qYzgh6uAd/1Nf5hmJK0kVF7yvFRbMy5kDQaFgFAuQVo=;
        b=eTFdUvKFCVdOCmDQE0ZbFNioC91PD+mtp3ajFgEPJBAl6m2Gz3/sF6P49tgpcOg9xp
         +P54hJ1VAsamlVehzwtC1dV5fHl7S2rOxGaZX+G89y5XHVpuGrBKmUIYQ09734tSJFMd
         DyqEQzo7y/WPAUsesdm4ptMM785gFpQGiFaDrhPvXlKMRAsKA9RB7GSkFFszTVI+MIsj
         i0aqnKpMjIPezB8sKG9xGT/LFcS1VHKvRZUfhWWNcSkgXgt4ByLSEx+9qe8OsHOnS69T
         YaG5RSw8TD2yhdCZKibyEuuiZWRHmOwVV1qvbxegM4dlwLmk/gci3FjCdBoBuY+IEphw
         vbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772961570; x=1773566370;
        h=content-transfer-encoding:mime-version:subject:cc:to:from
         :message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYzgh6uAd/1Nf5hmJK0kVF7yvFRbMy5kDQaFgFAuQVo=;
        b=PbPMMQ9OuzCaeXwojAj3Kcs8cyUIRdmLWGuULShINgMh9pCvV3uK1Abzt41qyFiQJ6
         4onhKl+laosFuXP91qs7H+76sk/07aS7mw3N//zxfQXRVyRr6MGlNyCKYtV3r77Z7w++
         VRstcyOTSJ9+vVXf1bYBOPKUMGjyI1P7lj73Q3RijxWVX6SuBTZxMbglWLj0DL5W+DZc
         GwGLCeF4q74FsWIBrrnm7LgdOuF68TOiSbSQ9kJfdob61Mq1kAhNMCVh3wWmG3JWCQvG
         8GksJNC+c+jkLY97JGElI7jx3JHPvkeEpy7FRRlzTWPXYBykK2PE0VIfpez37i0LBS0z
         0S0g==
X-Forwarded-Encrypted: i=1; AJvYcCWtt0o7TCZ4mjW/G7Qhp0iLQh4rs2tXqXLlWuGy/VrhiDEG/AlWlMvsSXrTnLTb693DMJN+sUY2Eg==@kvack.org
X-Gm-Message-State: AOJu0YzsWicB+Jjav2TVCuk5SmVrwpRD+G8n0CY6fQyd0pQsZ8LqWCr/
	08XWWZfMz3rJvoQfElTghr8zE4yR+D8xDKZneL/oLU8fxDV7oMBiEHde
X-Gm-Gg: ATEYQzzLCQF78DUX+2IoP7kxBck1X+kdH56zK7mHclBPj8pwOjYlqd+I7AbZt2Tu32s
	+GcHYucDPSETDvGBG25YXjbBE6wCli0pm6jCtMnO0IfFRkl58YCPoJMrZTafWK3PdWheP6hPKPe
	yzYb9bL9/3oTSJQxYC2SPYtNfoMevBTl/GyFGO1sQkt1a+d7Bu8LYHqmKmJwcEvQFUBVa0SW2ko
	Smauxc9jrAEZqN/z2McXYX9YplW9mLJ6muYE4MIhOmG9/jdH6aD16Lo9ps+16Qt39yrRrDWGZa9
	w3Avs6KmTlyslty68ZFfG2btAmp+KtQzO7gMxqBCoihB/xRiKawbLowIQtm3FbGFealHfUZjDMb
	58RxgaOFz7p2zcuUur8jipOJJSK04EKnE0ZBXnUmzlwuhOITBvgQ2AFpnm1sQE+xgYuZ850LWMt
	/VVeD4d1sOsw12fXHlytrrHw==
X-Received: by 2002:a05:6a00:983:b0:81e:7496:f826 with SMTP id d2e1a72fcca58-829a2f6d717mr7319185b3a.31.1772961570117;
        Sun, 08 Mar 2026 01:19:30 -0800 (PST)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a46765a6sm6709106b3a.29.2026.03.08.01.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 01:19:29 -0800 (PST)
Date: Sun, 08 Mar 2026 14:49:21 +0530
Message-Id: <v7f6u19i.ritesh.list@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Andres Freund <andres@anarazel.de>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, jack@suse.cz, ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d1imcwwxnmgyopr1pi5g46i5oackzb7c
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D18D180002
X-HE-Tag: 1772961571-809923
X-HE-Meta: U2FsdGVkX1+kdRjPA8gLDB0ZbXZPfqGZ4JAZUE80YeXFc2P4OUaVUYt2isFe232uU0UOJyJdcftCelIEBAlFVhapdmKX7HjA0GevcYrBUTN/NWugNp2N9o33iKmYufsj/logAX3+v7BjIx8wxLaeqjZYIZ8RSdFIVNlGuvJFTr2KeKUY/ECo5JYXM7bBy6JrgQjClHa9Zyoe0SkyvzQ93FPDijpfW7VxrqIh3LfXD+P4/pAFxrKs4bUdvRWv9gIyj8ilYpI6/91jx0JdgRItjCzmhmc2jrbaayJkZaayx5NnGATLmvCQPCDe7Sl/7lZ6Vq7ij6SNqN5kg9m7hvqZjNssRC5ht3gbF8B2ZYAPTeDKVv/w5dZG4addY1dz2jyVSKe3xAvzG1uTQZgaCxOLo3K5vKsGBbqF2GavTTrw9/CEU0cd4Gy7ayW7bsRB5rJsmcvwSrHfEco+Ks14hy4tgDPXYdlg/OR9OH0AXSAjOzDerbOlGdKT8ap36IoEzc/YhN0hX9Wo7FMsmpev1UfLf3RCN7p6yli8a6kr9NdJBjCq1S21qO5gnPdNTeP2vhM3UxXMKnDoxdAt2BBdDolJ00cWo9WPUquPBaqVN+MsahG56dzVxegxUp2zc9gi39RcY25Wq6D4LoukcADFKsRtkcrSlhDT0AHAJLCICahp9XFeOVn7ePxbo+Ogi63YVGIGrF9ajVEjreTHZr/enCEIplbA2tXf3Ch4Ik6wYPlVs2TBw4L4dGsrv1TF9oeNGv/uLsX4ylcf4pSDRtKOep+qAl5ARb59pn4Rx/bWkZAQ7cZ+FHuCyBonSi+R+cDlfd3V2jjkpvTE5MFNBIdNXVo/e2m7A0+dNZMrkCWf00/iucuSNAl0TzanwnFD2m7DUJgUxNiY571SKw2IWVYerUf/fTBwctdbsq0wHkz9yhdRgbs26IS5bfpKdVVQ5vOgCMc7kIb4id/BGA9XFYcbOqs
 j56yPC6V
 yThiQrJ2jbQ2kNvrj5iuQx7EHB7tlSA9qPEnlK6+8t9I78XZZ13yYKbzsGVCfNHdvSsLa9yC3TS48GGIZHz5H5yjGkz5PmuRrA1EEhZh3+J41UaRXixq3KWQvAgI1ilNsqPrbfCrziefVeoTnaWdBYKfq6LW7FVL2M0HtZKgddFcb4TpegFMuGbuQKhofZuFTADIO1+unMkAFxNmssI6kvI5zziaNM9gcURD6SnqYR7zDPQm7aGkTdNpPOXDksUD4kdDj4RUQCBQ7fMr2DVKRwzkUb8LTmw8LqM9kcreihlda97ylIMk9Cg3L3ptxsFE1BmSVtCLMODNt9FDmmy/RKTe2Eqj+UA06ji5Ct0D5kZnq2qeOs/1LMHZt4TSLmaS9+BT/fFy070XKOW2almzYLYg5C5EWoH8m6UWi7F1p/9bsrV3AhDH1JhbCdru0dmXmilR/jYELbQhTKDYJ1cohL3bRQmS2mdBN8zvyjHVCx3nyyEE6ai+YXP6pj+azs41Eqk6wrXZTs+Aia9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andres Freund <andres@anarazel.de> writes:

Hi,

> Hi,
>
> On 2026-02-17 10:23:36 +0100, Amir Goldstein wrote:
>> On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
>> >
>> > I think a better session would be how we can help postgres to move
>> > off buffered I/O instead of adding more special cases for them.
>
> FWIW, we are adding support for DIO (it's been added, but performance isn't
> competitive for most workloads in the released versions yet, work to address
> those issues is in progress).
>

Is postgres also planning to evaluate the performance gains by using DIO
atomic writes available in upstream linux kernel? What would be
interesting to see is the relative %delta with DIO atomic-writes v/s
DIO non atomic writes.

That being said, I understand the discussion in this wider thread is
also around supporting write-through in linux and then adding support of
atomic writes on top of that. We have an early prototype of that
design ready and Ojaswin will be soon posting that out.

-ritesh

