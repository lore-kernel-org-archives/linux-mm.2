Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A51606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hEpf3vZh
Received: by kanga.kvack.org (Postfix)
	id 3747C6B00EF; Tue,  3 Nov 2026 19:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3256A6B05B1; Tue,  3 Nov 2026 19:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214D06B05B3; Tue,  3 Nov 2026 19:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 066876B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:55:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E04AE1604D1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:55:36 +0000 (UTC)
X-FDA: 85395618672.18.7BAC29C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 19A1020002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hEpf3vZh;
	spf=pass (imf03.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=L3AIWxe9O13lOW1DJG+kqQP6JpL9tqXYgVFrP9CdyP09bKsmSzlrdzmbc+wOoLIfjoxW4S
	RrIhQF5rrp4G/r9LZrKs+Viihd3w53LGCMoELw2qWdDfjA4g+PayRcxgydYXeMYkAhvmJa
	1dIubIbYfsovsPR3ZWGPxrUMn9C4Zso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753735;
	b=MGxErOo+8hWsjE8+kJ9cYPwecxKX3EtfEGsRCJyfNgzfeFYtnMLDulZ95cBu5WG7vAzGlV
	Pvp/fEXuRT7ufXNcL4Q+itgawh47Ybo8YFykkEOqS4239MW3R0ZoPryCUBvbM9E2vceK3a
	Bbx7PSZCswYimzihWmdLkmb3gcQ1XD0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hEpf3vZh;
	spf=pass (imf03.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso75103a12.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=hEpf3vZhHohFOIXdKZapTfIEzNKDi6nIAiEvFOfI0sg6W1Of/13PodsHSIKf2gPKUH
         ox3V4eNHF0gniqTkw2IsFsS3oP00iVMvc1uN9gpkV/cOr3ITrp72h8rSit7zdrArQyov
         uPCUrGti4cgpxQtiP1mz6J+AHOt4o0s6paTDrFZVmz50B/NT2H+5IpKyHrTh3QsAo+Az
         L5Y/h0au5Z2EfPYPugCG6oE9rWbCYC6eOV+GeFYVhapf3ZYZ+tX1BMEkFX4HlK0R+Hze
         lA1PwNcumq51cQS0/Cfo7V6HvnSEeGsIr7MPSq9o4vgbVYFqB2JqdqOIgqRpPtchIotq
         0MsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=FUylFGn1l/KeTsfEx8K5cLfWGqeyAQixcEQYQcbTS2dVncStE+faLhOVD5gFncuUPQ
         w/Xrbhn7FsdvAdbHhf3hzfJOzv9HrBCyzj6AmYvS3rUDw24uTmlZojWQmEHqxU3BmTSg
         Yr6JBEjzER4Y7lrNU+rWb33xDhVo/qGFzBA5q0YHNwmzLkmd1nywJct/+Hp1y1mJvIuQ
         kwq8ZLpdkF9a+RaTf4ZxW9bZLA2EunSLzHj1TbUme/onBTYcU0HkXPOKgnCeX0UDyvcT
         eplvSzMF71Rst1Xuq7FDU6n6GY+qyKSujKgkIL7FsM6ndT/xIFUn76g/QEcsc9lLUQRB
         G6Pw==
X-Forwarded-Encrypted: i=1; AKwUvBxwVznGZQCHys8SOy6OkM+hMcFn+04N+Okog7WdFvfPQkCHwIwCUr+C20YkzKzVHeHpXNnSs6WXgA==@kvack.org
X-Gm-Message-State: APuU4Z+4LOmRJrH3lWfv+o2oabKtyPsynyYj5ioVvB0x1L+15ADkJEqG
	cbIe5JqlbFlke5qdm46tYylF4s8UKnXSSNfEpfVJq4o6jwhNsJ8KJxd1
X-Gm-Gg: AYBFou239L8SV/tHf/g2kJrJD7ToKhZvVoCfOWdBNFGEYBSL9GWSMrrxjNod9yBv8AE
	Q9JBxSxjy2YNNYzzbgE++cEiN0u9QTDJN1boKpcNVmtK2kczXA4klIY69j8yHgTYHd0AGLydWiG
	OIRFcPChUy07K9WnkYGk8Pa/P/7ISAnGH/y7Y2KzQ1EtHzlNb/RMsFpxmq+ZQVGc+ebzqriUwcy
	A+y8FmZ7UBdFbCQCK5S92qc/POI0yineuz6WE/SKxeRp3kCj9TD+JguOlD6mbPx7S+xsN9Y7NTq
	QBbzoRDsIWhkEOFnbwYgg6MpnF1H348t933BGkaiSb32GafVw2R5UvniQy6yYIE1JXvOlpsoFr5
	qnsMgjPf945wQEy8RQUTFT5Qu8uLd8kURb6JSDf8qxOBZAPc1TLXBVT8znYuCIYwqZ05iiSwdw/
	PfnTOWwD0ePVOMU20EqLDzHfnpYMQOSbrrbhEagckpeYJoY+IZ+u6bUauXLRczng7eIsGO1Nxao
	UsZoiA/J4AsFgEIUff8/Nj4rTSJN45xVzUu0Lq4HLkf21vRhxJ09O4aFYtfA9uuVVHuAN/6O8P0
	sZePhKyYmXtgCst3zQ==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 8kwdwgq5kbf86ua39h45iat36u8t4za6
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 19A1020002
X-Rspam-User: 
X-HE-Tag: 1793753734-187772
X-HE-Meta: U2FsdGVkX1/9QgEImhFSiU/CVhoBdYb7CJ/OAV7H9uGS08C5pop7DNwPUp5p4oetHBS2T3F/aasM60O8b5Nk1MuHI7gONyz0vb0PdfEVDSeSVeFFvqMybYBi9neIvDk091F70uh5OYYCx3/c3FTKAtg8SME5TsPeQ2XQtBsfgBvY/kbT8FiARoFTcsxzRHtkKBXHzskGVQoitJjVoTFOp7RvOsebinQpqcsel4GxzlqKmXzvC0j4xkbpYQypsJcKKZQK2OtOdYiXY3IrBC1bbuRePliUsJ9xtchx+36fg4Mq7Pe2fXTbrt6QrXKeoPdZ4mbwaLDw+UnHulr3JrFae4nT2lzNN00KtnhHADr1F3lnwYuFYMqS1bqc8OyXVFPJevyxXBTMroY2558j+IdrjO2imxFaDYDutiYXzhH5iSNAJTsvL2FDu6GS3VqOs7EdzpunoT13ScPll73vwCDVDphGEyN2OXgfgGX5p5zExz/4JcBjChIQpTo+HKytMLe+8d5HqhatxktEFswuzOzoxuONVw8agKfsESdSY1SKMJxe7i9DcSNqCVQtSYaVOlXeszSzpBZ0LXN853DmBjXAjMH/JQsQfGtM1HcO0fR8X9j2tuEPg9MH8ndVW4XyoIOOJDUV+/jG9RkOQTybgYv3xT7J2uUwo8cJjNmp1GDIGsIAx/f6Ae2DOFBKk/5UyLGk2GKjx05sEaFsIZEVfIfBtY2va5jhvO0VUArvrhScAyLEHlkyydtH1Rm0onelZWd4BjoG/JD2X/rjtmC4hdejnoM/dpZWct1f/SkgP+bKL933RoChCS7lbPMyupIkasyE0Phr371UQGrn1OhrvjLio+A6K7wz0nLiT/gx/15i7d0fQxs++9216/kLI6IpvzEqeHkFpBNESVRCXJJSAH4cI6h2L+PYTYX4iUEQgo+ygG27ftj4jm4GyF8RRSSNpXoLQKJj/RTHLPg4mh+10ZE
 GjiptDxK
 Bnh/thmC2DOye2JFO7LXdy1PR3aKzKWKi5CVcs7S9Au45WTeWKofCq0PQ7ZxwCFZMZsjqBdC45X9GYsK75fdTySxhvrtFYhSxNApylpo30s8KBtGtVdKudmXxORVF15zpTzuAT+hjAQdxGN/HqXBwV6/CpJ45WsFUJViRggUwnt/XHYJiOwitU8QoKM/C/mXIQY7kdoTN8WS/JkcmtBmvZjGuqxAraglCok/ZCipdL3MIKPSY4WJZdjB3b1ASE0cPs75hNNfeQtijO+oNfngg3tm86XUIW03/VbOvQjWIE8z6la0rNDQsywNPIMAmIErSRgS1BFdilQ/fHp0LM0rjTd35Hnth2u28VnUCGkFjwVtdupuQgoKQ1IH9DCBKOE6uSCxey35hE/oDqUQUhTBEzEMx1cnIj/uHZQ4/8MIvDS8y9K6YicUFSeOogwG6kz7pcXWxYRPVusQpCYhwuGe5TXoru1p3ljZKEg2oAQys1ftb0mAhrTfEukrw44Zq6pOF24wuz/IGyzyCq2MaZ6pNXAtkmKhV93irVk5P8z54fq0mGA/FXEAHL0X3JuT9sv2K67TnlQtA3niMfXbnrRw06V7tQStuao+WFdD3pCsuP/ECMp4/AVBMq+++33zLriTU7uCKOndRrLDcChg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul

