Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE5A606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 07:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qMT/iSQy
Received: by kanga.kvack.org (Postfix)
	id 7E6816B00EF; Mon,  9 Nov 2026 02:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797B46B05B0; Mon,  9 Nov 2026 02:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD636B05B1; Mon,  9 Nov 2026 02:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1826B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:08:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B549D14026F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:08:46 +0000 (UTC)
X-FDA: 85414703052.07.9C4655E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DEF11180006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:08:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="qMT/iSQy";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794208125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R60RtisWcqPaJsP3z5umkKLOFCDRWj8EeZj2DKpMtAQ=;
	b=I1iXJi+Grh2rRujdppQ0K19L/w2SomXMluefV7jvV240o0Mvyuhu2ikTrpfUSLST4fH3lh
	7TcBcY37/NwXAUNbjPFXiVWzsJ5Xs18Tt93F0OkZGpbva/sENXc/Fa9GxQ2KYbZ/kIIe5V
	TIHZtnUTkW5LjTVbC6uyYmGIqSJJYzk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="qMT/iSQy";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794208125;
	b=dnU7NX5LoCV1hIXovGso6p7NdZRU5rrXj2ugnJwV07THztgXFE0XFs2Ln8dm+M+GWiElX6
	tzdwRDLaV/inNJ5qz0usVdQXrQG1YWW/NTHCIP7AGWPOLF1mGfVjhOWYxl738lyDHesUfQ
	MiDL7FEUPEzb7A0qQI3aUEwxuUWNjMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD594405CF;
	Mon,  9 Nov 2026 07:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E782B1F0089F;
	Mon,  9 Nov 2026 07:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794208123;
	bh=R60RtisWcqPaJsP3z5umkKLOFCDRWj8EeZj2DKpMtAQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qMT/iSQysf11EbkSRNfEw5+UOG45cxeA4/obABZTaIw5jUZNkssXGGYgeRSJMbaYy
	 4E8KZZmnu6+b5WKd/WEV/xp+PLbFam/lUK9OTHuHSBpa5qP5AL4fflcKZd+3cWe9S8
	 lJqz1moFNyVTZFHsRQlHIuxUMxLy/q96EhQPpliE=
Date: Sun, 8 Nov 2026 23:08:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
 linux-mm@kvack.org, baohua@kernel.org, dev.jain@arm.com,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, david@kernel.org,
 rppt@kernel.org, leo.yan@arm.com, xueyuan.chen21@gmail.com,
 chleroy@kernel.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ajd@linux.ibm.com, jiangwen6@xiaomi.com,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and
 vmap with contiguous memory
Message-Id: <20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fmr5tn3gnz8uui6rif81tdd7xuhesx7p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DEF11180006
X-HE-Tag: 1794208124-732969
X-HE-Meta: U2FsdGVkX1+Gf7yksbwMfuuL1NpIJaUORfRUK3D5jWB1qxe8vbNowNAO9RjeINeB+COvKTCTBVX/yVVcn7fkyUJU/Sb+24lHaeb7YpLSN7wH5/hLl5l3FlQlzDglMxUskcgcQxdbac2H00ezgVB01ggETfvVA/ZeNYz/9taXJiZRGifUSnLvPIyj/Fl75cFu05zqMX5h3S/N2YMI/LB+j4luWE6vVNVKhy5yTPhZheq5+QhXTYZVukDO4ZUirpuViDUQ0df88cWZaGLxaYW9T4b5ifm5BK1HVvry0RpimN6vmgJWpzUXg9fAEfoAMY4ph+Jkd2KerAft2JUiESV7kjfaDImO9BfQOgy8Im4XVzI4OF5O23GZjFDDwcMrDWEr/jLvRUodba5OzU3TSLTCuhIMugCQ8iB/qmX9+OD308Y8zxjMGcFcoHgZXVvuWnsGNEX9kybEmEfOXOAv8UDKGxOs6/tcLsz4/Rcjsc+w04uUqaabGEl2yGRWXv1m+YVLzsDSUV+xMumyfYAAopCvKG5nAhLSlAMOQ9HKJarmiW139S8AXYDiVRMiea9j3kdtDQblXQ7tn1sZ7DzS3PlGq4vLrioZiZNZ3gL4gTQPddVkJUPZyKm3bPR6cs1In5sqvFYIHqZmX3t2yL0dLHUN32UwqPyhHS0/oBuuKqBVgoWbxsqzKFbOfW2kM5v1Z2KlnlWJCT0j9ZVLwTyIZ0sHwl9E8bRtqCYiGmqYiBJiRU9duTx0Gs/NGJxUBNM0e9sk554S7p6jvsVeHQ7EX9qlQQUSOHxun44caayLhM7WqMAcZ0s8g0xwfMOF6VGl7eJt7CnwKPaf8MIhYoGAV6cfqxjmYjJkWgvfdX4zlWfkuTUj3OO2xYvGjOejQ+AEsO8u0y02vtFyceYfNj0QWOj56ltWxzz8/lj1fhSxh+E9A1XZe2Lsmpss6e62mNicDwgewIpjGqguVSEXAqi+YDs
 ZtxJkTgo
 1Atj6IrQ50e/rtmeSkCdmHXSOgCvJ0NpooTgnanSpJDrKTt4/cfOZ45lW4gEgf6VZahQUvzxeII2MjK4I9dzZAGxEfEGzhO7AupZp0iFl2bDyQFjny58iCGzFqsQWd1l9lMp2Ep2nD4ayb+cBvQSyyVrLp6FhbYnIZTqq574usm4RwFaq0zEsym+sw1s5Jxz6b/5rXsjj8itcFqn4mGfyhtCWCky1Hvk/8ticmgARyaKy4BPf4vU05FuVqF0YYigCsWXTTJKa43SyrgTRJW2lz4lGKHhau9y8cVGpUoqs9k6efPTV6RBbSFinFwJM7J21FMUPSTzAFSQW/LyHPqFM70yEyqf/HlLu/N2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat,  7 Nov 2026 21:49:43 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> This patchset accelerates ioremap, vmalloc, and vmap when the memory is
> physically fully or partially contiguous.

Thanks.  This looks pretty mature and reviewed.  I'll add it to the
pipeline for linux-next testing.

Sashiko likes it.  I'm working on a different AI review setup which
finds different things.  Very slowly.  I'll let you know if anything
interesting pops out.

Do we have sufficient ARM review?


