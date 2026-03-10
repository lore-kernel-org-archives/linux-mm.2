Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27752FD2D7A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3006B00DC; Tue, 10 Mar 2026 09:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481456B00DD; Tue, 10 Mar 2026 09:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338476B00DE; Tue, 10 Mar 2026 09:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 202A86B00DC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:22:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD00D14012F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:22:09 +0000 (UTC)
X-FDA: 84530216778.24.A5DAF89
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 481A1140004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:22:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ADQQpd+b;
	spf=pass (imf26.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773148927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=2v3sZNqwKWg6YC2aGYNMzsrXN4mywjS2kwfhqZSCl8FXVxc8wIhuCdgvqWumTjJYn3Ruea
	gzyPPpiO1p8SHx2eyPkEZSPoTumrxrMo8cKl1ldecMvOty8WQnSNLC3mdfAICeoOOkmjRC
	ZUO7TXGzAr/tc8a71GC7k6r5NP+ktWw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ADQQpd+b;
	spf=pass (imf26.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773148927; a=rsa-sha256;
	cv=none;
	b=HjZy3LzHJ6jkW6AADp5zpIf/fRi2kSNCRSdhaiAVkv/kqYdI+FNGrp/8kG297zdo9v2ixs
	WMrO4YRtA86ndJKx3P6YNbl7pWUP077s5Bfz/Pdhs6u+lL+97fAIqsgpdtz30bMmRVf6Cb
	Vk0k0njqDDE8nAzsUNOQdqxAh7TwBx8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773148926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=ADQQpd+bpcMvyiI6BuK6I/AtlFPVjRaT1jbvm8x0bcg2sn4Mv+l/q+wGsOaa7zGZavpvJL
	HOw6n0NTrJxN8BVrJlzy+3Oyq/AicE10gafpjzfnHFVMImjvlOy3qRSEO7jpexZVWETsUQ
	RoRPrXnJkd5ZbUZ0X+x9wM3CIJYSD9c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-H3gFUAkcOUu9OGht8q_pyg-1; Tue, 10 Mar 2026 09:22:05 -0400
X-MC-Unique: H3gFUAkcOUu9OGht8q_pyg-1
X-Mimecast-MFC-AGG-ID: H3gFUAkcOUu9OGht8q_pyg_1773148925
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cd773dd39bso2180666285a.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773148925; x=1773753725;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=XyGl4CyyyqL6Q1xSPgcgXiDnitKd4YudUJ9oEfaEn989VRBuXPlzOBsrMxjeqEKizq
         VU/p/Fg6GGTFx6vEVJRyAQAYxg0BXYFxPicqcoYbaCAeCyOKoW3O+VJEFDh5+Yw2V4xO
         8tGOD79VnZ/2tELfBgYBIwUyDCw2JSFPh8QT9CDpoG7r5VmsmrC79RNRA7UoQIBc2MVk
         RP8czBMtlTllD2piU7byiT1eBbbWzzus9U1CENF+mIBcOzpve+T88s5hKW820BTp9wk2
         yk303wbmjdqBFMLP9LeJqgEDYQW8n4DaxEpeRJ6X7s0Ox1L+kDc2TuOFOx0hxn0PHGBg
         5asw==
X-Forwarded-Encrypted: i=1; AJvYcCW1cSWOh0uGXqwrjVxtiupoEzfJ2I6+E+7HNbTwEmPB0ZWtUDprGjRcZQ6PkZ3tRxB41DD7o6J9Ew==@kvack.org
X-Gm-Message-State: AOJu0YyWpnyopoc+rdrazr7AhxpqS2MKjA+ktVD7ODSbS2p4HdcwsA3e
	mrfIITCyteNBujNvxEJzC3jmmEfnYeMgyI3qmQDiX1tFnxj2AqBdNk/waPIvAsKkgTN6oJqge4A
	QsEAGIgEuMBUD9n+/ck0fGlEc3jpg0vXmaupZDtMhe9zSJZ1U/93a
X-Gm-Gg: ATEYQzzWpGjgVTbc3ej7FhMxU6d4Bwriyox2Ez9iWkwXpgymsezyVQLrTeKw3+c7vt7
	xFwzaTzk7yI3UAhoeZLg3/XYlHbDeppRHXp7gf/kAtJ8lxv0XFuFd8g+X0BS094q+a/WbLr4E2X
	oKhfpPUjSGmI0hR9WLCOBEC2H750KI/pXc0+nnDXoHwkzRbG1unwfNGqIkzqwa9TXWBpCElUA6j
	S8Z6ZxpDNbGNmdZWreFDuzOdX/lJqSPz7MPnHfPSB6eJZbNrX8bNeEaGD3oAtrQKTKOctTnv+qX
	7p8JMGACnXQKlJH7dqrVmUVi0rC1mqmPAP43XfHoqs0wBLo3bP7UmKZuFGMqAxesuluLufeZ3lw
	RLnxS/dvrXLj/AhffXroEOfksrWPun+DiBItnmbrs70UQN8MxofmH30oL
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830785785a.45.1773148924706;
        Tue, 10 Mar 2026 06:22:04 -0700 (PDT)
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830766185a.45.1773148922638;
        Tue, 10 Mar 2026 06:22:02 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8576db0esm474754485a.47.2026.03.10.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 06:22:01 -0700 (PDT)
Date: Tue, 10 Mar 2026 09:21:58 -0400
From: Brian Masney <bmasney@redhat.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAa9vQg4BSxl1BJ@redhat.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
MIME-Version: 1.0
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wboSDCH5NrzqG3OOIDG-QluU4hJB8FlVs2gXf2Hbkx8_1773148925
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 481A1140004
X-Stat-Signature: ujria7fkkhpe7as5ncztzp9cm13z96jr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773148927-235918
X-HE-Meta: U2FsdGVkX195uog982OmeNUSdjBATZ+59v3DhxhhovX3DB7AQmxqG1a+lqFSMIILEJl3MFruhlCWnEXwfVA8kfCPF1Ny5lrMoE2aMwrlyE6E0DHupjvz1cdQrNKG2OMo+HFNvHqEGKhQH6ttGLMKGvfEsa8wIkuCMzAYGdA0BQj7FiF2vK/F2XF87FrBCpcK31SFX2NsWDMH+aZJhCsHU6sH7iwhClzNvm24wCoNAPN9PFwLdKAWAr+FZwBu/E+S2I3fKv5CaOnO0ETh0xRVQZazGmY/XkIVHYxAjL2R9THe6IPS/t8wVy2eos3DJNc/M6kuAhCCQcb8hQOKv18vdwjqhO3KCN3umhT82izY2ZIHyazchwanDkt+962HzcBe9ruOOJUvw0uSUJBKpWhbeCYJN71e3WjeVQJIEbhWB/G+V6633jc7KrgmvYUkfYJtIq5ee4GXeRA/hLVYXkmRlF2PbLYovfRn/eyVB2eGOi1VMq/O6GCNgKneLg11L9tnD7ypOkmRdjDGgEtWzobipVn5WJhktik1k26TtvNA+q5VepLF+qO6V1bz09nkF08suE3OuJF8GanNRppFTbMcgAwfyVarJFWuzaKMMEL41tfpePaQz73pb9M6o5rCvMz/b67EtQY54BQvFupIEBabRqenx5VuvOF5GKoxZCBYaEC4gmOMXVwsb2+MIWvkeDwmUnu0KAhVM7XI2GfX9nej/5aBs61/2rO7F8Xddy9d0n5P1QbUMq2ZEKgFUC6jbSooPHTW7QmKSPZtfYaTU84ycArdVziNbnMjBSEzq5GIQIzI01+Y4t/scDJ3zUOt8Q+cIXldP2xGlyCMyLxZI/IPGZrmA5C1pSd/HU1sq+Or6vABe1PiTXEoAxe6uOtOPXqJjQTbpZhaKmDHfthr57qkpR7xWhqVUAxBiN0u8KT3NSWoLYphsDhveX+kJRfiZ3lxqVfQE2LCeI0wbo72QRq
 yC+sMimJ
 qfQV3NJIodtSLv80psCeeQFRGLU4yXp6DHaiDsa7PUuq/hZ0AHLLYR1g3s9dsn9Q+b4bjDNzcDLgqPID74/gJcnCA6sf8b+2sB5WqS+KtVk5RZwMSRZSaQ5FXp7NuffHeYVtf6mwKwCq5UQvYVKE+J4pbQcFnF1qGbIH8D2PVL/2xzhgkKAhqjP51+GNpblR9PvOjus5WLi4+hjmDfPwPUIiDkWeFKcQ2gWB95+AsEJFI/xgmj28comT51kggzXmdy1NycWWSIrRNwM+OlC6FMZqH49cGcmHJYHIc/MOs/PkEHHSe9cJI69kO2fmblqDJFsbMGwDdt9RYY0fSrB9wK214z9rY1LzfHUCw2SbEgup9i4I5FSF0IJVhOyuzcZ1hz5Sao9haXNaWnCMTV24rvpAFtceeG37t+xhOXq+2KVYyCcqePxKl8M20k55BMVrLMbCclbtCmm4rbqFA1fy/jJ0SrMER2PIVJaODpUn5ETehELHJR7oVxG+8i1xCN1FgWy2sDcu2rUGbn/deNfb1BglUGkp/23aza8m1LZd0d13t1EFy2warNrJsGvzBSF72UtIvS4zZSaoOb+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:49:22PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,

Semantic ...

> but not when the pointer was NULL. Now the warning is printed in both
> cases!
> 
> Change found with coccinelle.
> 
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

With the minor typo addressed:

Reviewed-by: Brian Masney <bmasney@redhat.com>


