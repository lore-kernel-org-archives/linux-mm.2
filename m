Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F65210FCAC9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623F16B0005; Wed,  1 Apr 2026 15:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D49D6B008A; Wed,  1 Apr 2026 15:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA226B008C; Wed,  1 Apr 2026 15:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDE16B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:28:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C67244C03F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:28:25 +0000 (UTC)
X-FDA: 84610973370.28.2B50A12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01DF11A000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:28:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNbFpRGJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775071704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSg/N27waNOMYzpjYpPHkKZa6c5gQlQNNMBfj5Ys52A=;
	b=kx7mNcDpcnYphh2vemLRLgZtDjaoHE6PGpoY+ky+VwVmkpHdAyUyrSIiA8Inxlq/YeRJTj
	BeYhQAO7uHwhBgSt0CMBjrkTKD2ucPQev5p5ueNeUf3vvOmNY/Xzc1tV0qk+CXBqAfHRmK
	GY4uHtrS0JprKLmLV+VMCRNq/vtAc1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775071704; a=rsa-sha256;
	cv=none;
	b=ELLrMZgOpH6jDWsIKSb4o2casxUsUhscwffHp3DKcs8Nu/XMAaEsuB0kGzJ8eY8lFH6Zkl
	4KiQKbgJgu07wKZ9w4SC/Xi6TkfkUgoWgaUAVl5pMx4EJHUyZILefUsnYYHMA4B44B+dl1
	/4lWu7IF/4xSkw4vSAZa3+ZaYcIenNM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNbFpRGJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFAC044349;
	Wed,  1 Apr 2026 19:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3D3C4CEF7;
	Wed,  1 Apr 2026 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775071702;
	bh=fme8hyEq6LPmNJncesjibWSiJqsBbRwNp/PF6ClVQXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNbFpRGJl4xmGCqsJNjNwi7sck8ydvYFdoECaM+MI8+60dcA/yHsKwt6QrZ37uHXq
	 Ihkwn6X/Emc+wPN7z05vDcXTgFd2l0gLBPetCJ4Nk4KYlrNi3LI5jmFjvXvYHUaxRG
	 Ys6VuPShFGK4/6DKUIQ4Eua4SCmW3Xlw++iaDEX+fot9zXt03E4H463WCyMkW/YjJR
	 g+p/W7Grymw6Dl7CrJqLy5eceN5Xq7VT+JhE8t4OhbI8+hjY5dBbrHdE5TCu2q1kM3
	 bck3YUxwwrPbPp5E5ipAPgqv2o3KpZRHi1WoKIaYoU2Amhfg4PINjIVQ2RMeN6Blm3
	 2rBxRXchglkcQ==
From: Kees Cook <kees@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] exec: use strnlen() in __set_task_comm
Date: Wed,  1 Apr 2026 12:28:17 -0700
Message-Id: <177507169460.2890967.1588878662313985569.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260401152039.724811-3-thorsten.blum@linux.dev>
References: <20260401152039.724811-3-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01DF11A000C
X-Stat-Signature: ufboarwr3tkeirsf565qm4brtf9yz6qu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775071703-720210
X-HE-Meta: U2FsdGVkX18mRAKxhUQMkwKDyNVWkfjf8LOZWaT7VRbUUvBB27FLRGMxCXEIEC95892RBXgcGc5mKp40EeUnDn5Df0wNERT09wfIfVS2r0DyK0hxE8W2YNQvqqR+1jrV++XaE0RQWLo0QQC01JcuSw+6LHEhHXgiduB9FFWqhoJS4m32/5umaAKaQxoyE2HwyA29SSKGhP6GAuAwO+CXoTcTAtwlINJ/cC+uAm60GTix+5pJ/rRpWgIvGpf4IiyNNZYEbWhslVVuMqE+24IyZLkhrA7EckwhRZmdJVctar7VxVmNAs7zJ+hvQ7q6EZculWtPOLaEsxhv0KD2VALWIVyaU+SgulA4gzMJrO0cEyYy1xvtKsVZqBcM4IlxsnU0Qfa+UCE6h+4OyLAL9s9gg48xra625cG2ivYTLRCUo8fpFZXxgWOXKlmTisO+IPAipk+WaZ1sIoWafADe2B6sP5EhvqUNT+lxgcftDG+Hp/3kMJjYcHR9LHjfUuPOYTpTKJs1f6jO3/ANQcl0CPC4r59RMitnYNIU1i8YoAND8/nei8iVfEQ3Sinp75viDbV75vZFMfHRU3hYmwDHEPj7DP+Vec9jYhDQRpG9tcIV0AK1nCjxp1wMTm7rxqKJqJGBaKFRzoHlyNAlXdItKZ8mQcDBLEAqtlbslqgZMu6hQOwIs6IvGSYIpBo2cXfb3liMArkxc2C+39TPfjddiEN/bATntSyd84/FEQK56gkiqP38+Lxt+j5DRPoqscHZtfRlSIjchv9DAzWfO0inFCOiSh2zRRD3pV6PxjnG0kdWvQXJXbluMoUstfxygvMLVMqOSZlX2tuDLxyAHdBSRQa466PR1dmvchkjHc4nhYNHAp8tANh0eFby6cRhz6xdS7D3BHmnbl7u5f/xqqoS0v3nuSqc3fmAFdmCQGwM5pfYtojUJpwGtSUouRGbZ17ocq0J1yNJJUc6QDFPETnH+SC
 qXruGH74
 4rE7k5yr7EVmIef9IZ+txLL+EACurqv5c8aOm9lZFeqDvvO9TBGG3tPJUrsHzZdxNfg48NEshv/fxdz9fIClcCKGbdUH/J5nlKzdGTEdAl30BsZVpK41Md1D45WUheWZnqyUOXCna2KPbtwBEOI0OtlLhThY45RWr5f2szxVLvMHn9tlihOxy8O7VF/ACzHYJ6TgLM2bATWn/fO7zqCjATJxQgIEyJX3qc9E/R7aVCIWWQT89ev5ZBdhd+SIedIMbINfGGUV7nFtYTC5qi/SQkfBOmXI1rJrjsaKx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Apr 2026 17:20:40 +0200, Thorsten Blum wrote:
> Use strnlen() to limit source string scanning to 'TASK_COMM_LEN - 1'
> bytes.
> 
> 

Applied to for-next/execve, thanks!

[1/2] exec: use strnlen() in __set_task_comm
      https://git.kernel.org/kees/c/10cd6758e054
[2/2] sched: update task_struct->comm comment
      https://git.kernel.org/kees/c/9bf092c97b86

Take care,

-- 
Kees Cook


