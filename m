Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37184C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454EF6B00A7; Fri, 18 Sep 2026 16:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BCA6B00A9; Fri, 18 Sep 2026 16:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E306B00AA; Fri, 18 Sep 2026 16:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7496B00A7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:20:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82E8680758
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:20:51 +0000 (UTC)
X-FDA: 85228001502.29.85FB69D
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id ABDDD40008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:20:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gQWF7uXg;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKHYiIXSy/sUkOC1RnRyCN5D48PNPtcysE7SZpaqPCg=;
	b=7ZnyMR9WZFYuR9CHYwXloDgDI2qLYV5z4oyYyuBFPe0z/ZYtIFdRr1+eDGfIzrctW/N5Dn
	DtPtzCFndWj7fe4b/KfU4oa/E3EjhIQ8CDrf0PUKdm6K+H7AVST7/f3bztxn0SN8ud3jw3
	1c7mqC/qUgbKG8y3to0uAgWw5IguJ50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762849;
	b=fCJtl5xf3qlThkUfRlhrB8AGucUxhWOlF+dRqykAXZGKlkak5wyZAt6XJrDkK18apz9b2B
	f2qwbd+FD8Xnbv/Jr7WG5ihOdqu25jyfWZxrFdHCRZCv88GHqCK6czIQProi2pwRt/7YrO
	w0JBZmQmiVf0c9iVw+42lNa3q/ts5H0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gQWF7uXg;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so2005ad.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762848; x=1790367648; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PKHYiIXSy/sUkOC1RnRyCN5D48PNPtcysE7SZpaqPCg=;
        b=gQWF7uXgVf3MPzdhwQzYNu+bflzOPGoCRb0GfUgvVuL2WaH/P4+9IZqa9tPBgGAp+q
         BOPA7F58SAd14CQuKigBDIUcul/ZTWeUU+gw3YsAo8w0s1NyreOEA98jtXdFYH2nFbsD
         daPS9piqtXXUtoueaacocBdpD9sqomFrBAuROK0+AI/D46U6CzGxqGBKgy9ww0VzN9Qm
         3ots7WgYn+fqAU5QoX/S33ug3PsKJ8ldTHlzUXoymkc6TxiwnYlZ74foQ5T+Gdb/C3Fa
         1jsQqxikFL+quYmlM1ZFE/qDR4Mmj0XR/peu3KtmkDDm6mHqYwzyuLOWxTW0Cv0xqjOg
         GjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762848; x=1790367648;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PKHYiIXSy/sUkOC1RnRyCN5D48PNPtcysE7SZpaqPCg=;
        b=arHiGXzeA6Kycj/vIBueC8y2fKWRYaXIZgzTSS10Owru7TNx9DVOnscFtL5VXh9oZa
         lNumpRJzuEcDEZQxx6p70QP4/3bIdi7dbdXaHioiVfNaay9he0wN4ECnvLNkfj+WlWKW
         42WkBEyuVQoqFEQrN2nz67kkPLV25svVo2TJ63by3wp9wbGNBNHZZDa+pZ6o057KyFHz
         6Kwc5zIoq2DCQywBuSNITGhSvptgqdMKxfDlQTKBTxVViiPkgBgb7krIaTRcZUnLFpSH
         1eRpXg3nLYffNMjJdrnPUnolLTtjbqo5hw9VnG9smZ23Y84GrkXojjUTzAqKeOmp2tsM
         b5Cg==
X-Forwarded-Encrypted: i=1; AKwUvBxgbaV/NWx4i0643NyQTh7cHu9DsJxQihApIAn8BPFB0TboBdqysPgWPO+I1WlquglPZV9MH2cB/A==@kvack.org
X-Gm-Message-State: AFuF++lYBf/9HubsurZParC4o0R1ARxgw/wLHuIg9Zs1jdeWyd0KAE69
	gSZD1eDd6UATW773XMtgba/K9X7IcOwODyoPo6colcAtcVYQOLqa8rK3ARTdE6dRc7tLoq9iAhV
	cKkWEuL5m
X-Gm-Gg: AYBFou3Cu29upia/RUi3Qa39Avs9JIm+7hexh8413Gg/Cedezcwnf1WG3EmaTzPOmdA
	hTNxG7bim56LYdFdBER7AlOYssH8mpPEnYgY3ieYuM3ej74Dr3l7GN4ArYyZ1prJOtMbecJ4qMN
	WLi3YbxJvrI4C2LR3/TjCRR6Z/lBZR1i8S1JKwyToJx4L4k55rIizMMA2Kxv6+/PWqjpLcpP09P
	ew6viUIN22IQ0MO1ZanYH9Iapy/zYP62JDMlllVlKw83LX2EAmY3YIWej7KAWQrFJ+4l0hSYdk2
	tgkDxbXz01V7re8ite7meXwTCqpxpR8kHL3VaAMh6P4KYkjiZTBohPPacUgQ9hsRQt0b0rwfFga
	PjORLNIjtjWARK4IhXSxSwD0WSL2+1yUo+w7TiL0UeHGWiQJOmM164+8NUX0jtUDvCJz4Mldq6Z
	XPmkIZhxBjIs6nSdc9i07HdW3WfY+Vm+4+PU4GdiVilJWNQfAeHlSRMuCCX3ArxT+k9IQzQ86sy
	mcuUuiZQinn/w8CBrrTuXSXZ5pFv+YMdOTCOlZBrXZDiMCHCXb7Z9UlcGO/CmdmaNfpCRXqGtUs
	pPHoqnWj12tsvLgnEhk7h7FuzaKldn1wanCHZ03iBhozp34ZNgfKzG4eElw/4J4BDKBbk4X2sd5
	1zX/JhOc=
X-Received: by 2002:a17:902:f610:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2ddc165e533mr2194815ad.2.1789762847953;
        Fri, 18 Sep 2026 13:20:47 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:9a8c:9370:b2fc:a09a] ([2a00:79e0:2eb4:9:9a8c:9370:b2fc:a09a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c6dd585sm947935a91.0.2026.09.18.13.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 13:20:46 -0700 (PDT)
Date: Fri, 18 Sep 2026 13:20:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
    Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [patch v3] mm: test_vmstat: add synthetic benchmark for vm
 stats
In-Reply-To: <20260911223728.dfceedb4135e0b758df0ddd6@linux-foundation.org>
Message-ID: <1e628c9c-47de-1552-7a04-11a1c6c46e60@google.com>
References: <014ef68b-6312-bcdc-f432-34c31476fe77@google.com> <20260911223728.dfceedb4135e0b758df0ddd6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4hruqnqkm7ntfwukkz5ggsris9gbizn6
X-Rspamd-Queue-Id: ABDDD40008
X-HE-Tag: 1789762849-780856
X-HE-Meta: U2FsdGVkX19nFrclmjyUSOOFaPWPUn4Dafthi2I6Wq/28Ow2He4W8ag2dwlvFOtpXV1UbxtWXHcLhbLAnbJrLaeuU8nLIkgk8RagzPuBpqPITuUOEGEa+Jkw+qbNwcIQ0g2p890Wr07gCfiSATlecgI5xxOSB39UgGt4X6XXFh4MUQIF36MCIdlz9WnihHBxCFJxjRlhR3ZexQa0FzXxCaKthIW8xtdRLJnm/6Qs62Jpu2XdQT+U7R67Q8N0eA+uT0CJQYOuvVmiECnrfKGm6917JK4Q0LrKHnYEux6DWnHTiaTh/PE/TEP672PW8gWq5MzcbhJSEy7ShWvIp8IUYOd7m+UORqvt1M4ePSXQLd7MLGSOZjsQIrBSYqsVvLJuQyxXKtimOQKrywuUbpjS/HpzNFpESK5FobX+q9MAX7Ik36phjvnK0nMlMnF6te1bMZXjq60K5A1WFiGIjyYiyVX9vlt1SLyMt9lGCb1EfdNQCwJMi66+x8F1YOXKoqGa208bPJZ7I2+hYe8rfFf89ydMUMVUPVV0ZmwpoZJ/SN5OdQwsUwMiymlqe9ZS5eP7cEjm4zBP91kP4Z4iSriDcIuSWxzvO56m7jj6fHdvcY5yQqlCLuEx/IYfQgEBqtPcn35lyPJah/5uLdt9f1Cohf3Yg8Gt0bSrh3BOXgdyPIPYxTBTs39XeoFm0ttAA0CLLSxNMeg1i+5A0s/oBPsC4/S5stF1TofzPIh2DaR+psQY8Oxa5qneeniKd8JsdMkZFR99+imJ2yDU/baAm9v7aCEEZtUwtb84rWsDB/f/90/vEfMSQbzGvKaRa2ZlEbYopJVqm7HGtjv++VbfcT/tgPkwsfu7QlBBWST2JjAS81J174LW5hB6z4tSeYMuOeOkLqLGqY5z15Eq8fI3oaf9g8w4qDYj/LKSAGPeXP4QSgCECFYevqOMzokEGrAzMV/5QwfTZL91HStTSv5KRjL
 jtAHc3M9
 fTFCXEhG7ekJZLybcMj0zDr1+6Z9wVohTtsHEhfCXEe0zqjJP8yhqygiguun98iEDlGIAFksDffcLdnlT1ELyYTXcXkOfm0N+GVZqS3glw7DYtDe2uQ29KEg1Xp9PZdKgY1B2Sqhnbxp1YKpur+Bkmc2/0XC3r1CfJJKPSxnE7mtXFWjBFxshyQOJnjEQqOth7ZXxWem+KR5MKCSVO5IHRgPteYKXv1Nh9zlzKC3MMZBzKdHAa1wpCIS0Fa1Htq7J+iz9MhLdggZX6rj7ide9nkOuNfqnMv+12MsBnUU5YxG0PKyjp7wcMiCwvoehth9u2QS5UdrjCvAxUZ+48STNN2YjWubaPn70zVTNgyzcuP7A/sIUQwP7kwm+BPo/tCs1auEn2OCLzkC6hSQPLe+xH2IMvSt5mNGlwOREPHVO1vCjE2Jif6wcdoGPCpFU+PKwIMkCi8dTo1FtjBpdyFK52hMQdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026, Andrew Morton wrote:

> > Add a synthetic benchmark that can be used to measure performance of VM
> > statistics.  This is used to analyze any improvements or regressions in
> > functions that are frequently used in hot code paths.
> > 
> > The test is run by KUnit or doing modprobe vmstat_kunit directly.
> 
> Can you please quote some typical kernel output in the changelog?  That
> will help others to review the proposed change.
> 

Ack, will include the output in v4.

> Sashiko made what appear to be some good points:
> 	https://sashiko.dev/#/patchset/014ef68b-6312-bcdc-f432-34c31476fe77@google.com
> 

Got it, I'll use NR_MLOCK instead of SLABS_SCANNED since it's display only 
and won't have any side effects at runtime.

Instead of switching the type of the "rem" variable as suggested, we can 
just remove it entirely.

