Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDF1C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D565E6B009D; Tue, 21 Jul 2026 11:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EAC6B009E; Tue, 21 Jul 2026 11:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44296B009F; Tue, 21 Jul 2026 11:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBAA6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:43:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 090021C0101
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:43:09 +0000 (UTC)
X-FDA: 85013202498.07.4FB9954
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35D3E1C000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:43:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i46hQ7WB;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784648587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8km+ZQgkLUVNh5jQNamAtWyAYxH8WzuI6GZYyhCw5A=;
	b=lrIHZedMP2mVMV4SIEMW6BCj519iVbORaCASsZ6JtbLdtOSrJVZP8oQuvr2cI9tFydN4XM
	rMl+RD9J0JqofoDZbWpEuDxNHlm7lDzZjwYIR415hEZtyVbDInc66OAxrYmH16crYVBFFV
	3jUb+/kCd2zsnmjNrB9/FnZ9Lx6I9/8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i46hQ7WB;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784648587;
	b=7nvY1O4vAGM/pWO8kMA45W1VKUjNwjHoy+R6PBwUDLGXGLHOqaKtBj5mR+DXEFtaz3zG5K
	1b9dpGGFr2vPIqEvkgsD4VOkXDUEDco7fElTTtHbCed3YEnwupWIkylEwq+86xDl8al4wV
	7EbGhvawZtdJfdZp3HR6ogT0zGwYkSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75B014361B;
	Tue, 21 Jul 2026 15:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47751F000E9;
	Tue, 21 Jul 2026 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784648586;
	bh=K8km+ZQgkLUVNh5jQNamAtWyAYxH8WzuI6GZYyhCw5A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i46hQ7WBWTSjsJoo0+aveeWDcCrbR28cpcdsOhYe47u8VnVADMzUCzgKDgO1zrrFL
	 RvX8M8IyZbwW6+2/ZFYKqtdyCdD7Bu7yegasMnOCMW6PitAN9yJ5HbJKOCXUKS/Jo8
	 L6csKx3I2nudveiiZxOEhTUX4Y72B+kVDuKRxQiwFJVlPNIgxTlo2pnnik+08H/vAB
	 wOZJ3QkGLxPrbYexz4Z2lPFM52xsYgt5WeZbuKkkIur+qqoEMW+gxo5TgYo20cxjeF
	 8dDfaslPMlAeyIafDK2s4i66yRQGvgmYRh1ZHlvhjlF4y8buBZXjFVNi7m2f+SrPSV
	 Ve0R4XiL7aGhw==
Message-ID: <3ed2043b-88e7-4a86-9efb-fe788191e8e8@kernel.org>
Date: Tue, 21 Jul 2026 17:42:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout() for
 mmap lock-drop support
To: Stanislav Kinsburskii <skinsburskii@gmail.com>, airlied@gmail.com,
 akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net,
 dakr@kernel.org, decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca,
 kees@kernel.org, kys@microsoft.com, leon@kernel.org, liam@infradead.org,
 lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com, lyude@redhat.com,
 maarten.lankhorst@linux.intel.com, mamin506@gmail.com, mhocko@suse.com,
 mripard@kernel.org, nouveau@lists.freedesktop.org, ogabbay@kernel.org,
 oleg@redhat.com, rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
 <178413936536.1155966.8918127042760531802.stgit@skinsburskii>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178413936536.1155966.8918127042760531802.stgit@skinsburskii>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35D3E1C000E
X-Stat-Signature: jpfds84cwpru7encb7c5pf51ir4af1ej
X-HE-Tag: 1784648587-394448
X-HE-Meta: U2FsdGVkX195fn5dyXnkZpjLC/nkZx5zYvrzgnMZxxkfKD8BSgKSGnpaKHfhgU8qCTt1KmGcANwUtP6+ug+2wUXKJO/6Hmyj/F29NnLcD9iVuh582/VQrQYt4cjBz1/bR8Fv0yCfL9q0OzLtH/8DlViSW9tAKca1PzjCxEJ9jkfpNaNOBLVyrN/bO92bhjCCXFMesYoP8AbQBTDTehqNfKkSnA6K4zTky55cQiC2nLWmvich+yIbv5ZfMq2Gz1f8eco5HsqRzgio4hmSkCTw8cQpLg2ViI9myv8cZPfozgCkzPAgRLTstREYl7CwzzScSDXslThmRAQo32wU8z8/Ifz3SBTdctd4tHx4N4eutAEo+R62ChVkxhSikm82AvAEnQ8t5xq21+h33pgGEkEoqC0UUp7oUq1m1UhAtXc4AuusEQqMkix2giVARUat/R1rR48n8/+kC5xGfnf0aZrLFDu7T6jPFtJPARR1BV1OqZqvzV/ASQmTKSDKahpmcwUxSfx3+nWmZn3ZfyxPLiGO1AkkKotUVGp0zEG+mRscAGQzjYHyyA1lbBcwlSgTzwOwBf57fJKB/clE1GTIUjs46bXkQr7lm71K8SwxrAEMIvdc8aI+zo38alp4GTcLXBgTLFWu1RNPykWvEMFp2jANXf6NtwQMkggGhMi1R1Uw9buVTlf1H0xYOVctnYv+gaVKNZjk6SL/0XksXK8hIjfXmXQ0QLVGn5RCcFY5h0Kb8DLZaAia3sVP4OheuVdnntDM2NzvxA0O91g/zywma4FPsLIsQ8QGm3xbFH786F1wHTslpRffdHysIIbjkST7VuDYj0FjNrLdA8RNSQm5MiLjHpru4Udr0GOC8TKVaFe0T+hlbulU+CJKgYT1dhFWCmXlKtvFa1k6q+BVwtgklUgYw+fN6vUTsJhKqqV+nNKlOBuw2L+ieEIrNHDOHFS3TZE/WQF6c3dJmVaoAeK0/rL
 ke/LLkWU
 3yeTo+c66HsGo6d6hOdMRaj00ZaPjP0zbvI8ZM5EZJ9V4+pPtxSZK/qQWhsbhRtRKxEcx4lCaYy6SAvmZV+IYQUM3HkdY+X2P4ThlBhPI0BmVI6PNh/cGur+H4uo+qbL8HPJ76DEDz4LzBcaRO0rFWhJQSvfDSNVHQGYTpuX/n6+Ow3IOcWUc5aALel4dpDXUf5dNRcEbbyGckFaO+WmU5gm3jQRsZ2jZwDMSHtcXMwlG9JrvT0JJx27DY1c5R+ovzAGjXRjkgm8aeQZNr0/fefXrNzGFIKHe4+aQAqkfMLCvOJRAqlYOr1xAqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 20:16, Stanislav Kinsburskii wrote:
> hmm_range_fault() requires the caller to hold the mmap read lock for the
> duration of the call. This is incompatible with mappings whose fault
> handler may release the mmap lock, notably userfaultfd-managed regions,
> where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> after dropping the lock. Drivers that need to populate device page tables
> for such mappings have no way to do so today.
> 
> Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
> mmap_lock across any work outside the HMM fault itself. The helper takes
> mmap_read_lock_killable() internally, calls the common HMM fault
> implementation, and releases the lock before returning if it is still held.
> The timeout is specified in jiffies; passing 0 retries indefinitely, while
> a non-zero timeout makes the helper return -EBUSY when the retry budget
> expires.

The timeout does not / cannot affect how long we might be stuck without the mmap
lock in e.g., the userfaultfd handler. And also not how long it would take to
actually grab the mmap lock.

That's expected with the timeout, right?

[...]


Nothing else jumped at me.

-- 
Cheers,

David

