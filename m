Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEE9CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08478E0008; Mon, 10 Nov 2025 04:10:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8028E0002; Mon, 10 Nov 2025 04:10:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDFA8E0008; Mon, 10 Nov 2025 04:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1B7C8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:10:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 261BE12D8F0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:10:38 +0000 (UTC)
X-FDA: 84094126956.08.E517736
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 612854000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:10:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cptu4PoA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762765836; a=rsa-sha256;
	cv=none;
	b=K534x/vBWkxa9NRMo4oESikNk3BlsD5eVwjy/pBG6lTLm9aVclyLoiH9Qn+pZyXDwz2vf5
	tjZQSg0v5DfBa4gX1REeHZhUCvqxkcVzCrIN/JY5SrTNiWgJFdITTw8Iy61oQNtMJvBf3y
	4umwHDi5StpMYi7A/BubTDlWd+C4Rn8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cptu4PoA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762765836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZZHMspGdPkStuR0bvPyZSjA3B1zZF1XEk9fjrjBXqk=;
	b=pmm5pa4XOovDzLkp/8TctLoLeK8gonWKn50QI8vsr9QZGbRSXnsV6PW0UO4vtCwxwHHR9u
	4KTX898qmF1+33ZP6974o2RCxZKZlSn3jnYoi1OEPVbwLHOkNxFBUur9HxR3rFzlnzPudH
	uPJCBqcTpHR9w3zHaxe2Mr08qjCc2xE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 527044446A;
	Mon, 10 Nov 2025 09:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0ECC16AAE;
	Mon, 10 Nov 2025 09:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762765835;
	bh=JaMbg32qNbhqE9b3hup1M5vDrFPhQ1dnIjspZzUhRNI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cptu4PoAElCXw/Zsn0aH/kXbacdIMrfama9GATWjRk3szHMgRzqgqYav4DVAcYKAO
	 +Ai7kcqViE9GRpWGNvC77I7Cgu1Pxn97HPad9JS61bhTd0lVHmXzhRPxACQFybqExe
	 WBylyMYyK5QGkuXYpgVk3DxUUIPPNVZ1P8ZOegkgEJ1iS7yLmg3mGO4cc7iy9v2ONh
	 wROi4fErM1J3Uu//Eq81YktEHuLCdKMTkj9H/K8ZdGWsf02UBmP+lUFCLqIK6J41w/
	 Z75xh9pDdLCX79oDp0JuFkooPrJQ977rIFInPleKWGmRCChskTWEL/XWL/5pF1zggT
	 GK6F4Im+EGcqg==
Message-ID: <de1fcdb7-3597-4d4f-ae77-79f79f9d2268@kernel.org>
Date: Mon, 10 Nov 2025 10:10:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftest/mm: fix pointer comparison in mremap_test
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20251108161829.25105-1-ankitkhushwaha.linux@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251108161829.25105-1-ankitkhushwaha.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 612854000D
X-Stat-Signature: xx816cqp8m7tijdsf74icwa9uwzigraq
X-HE-Tag: 1762765836-225751
X-HE-Meta: U2FsdGVkX18f68IjeMyeX9p3OceFqcRAJX1XjPRMOkn29JL/EQoX9Fku3Xm7LtvrE2nFGiwGuF36hS1NrgLH8b+YaFFHL+xhqyW1f0GodAR5ir/DbS5yeMEFfifuCoIolnovi2VfYYv1/Iys041F1mfXo2lMWntThHuDFrkuTIkTdF5q+oJWufxGxsi5j+Dq11a790PC6soA0/zjOd0aJFdODPhpIe+mzR50eHfL/R3gDDXQPLFGGZ1Qs1CNtXPVAVESGFHXUWXGdFUe+nDeYMSd9KXmPxmU0jWdNui5UbO1ACAoCFGJJwuZ3K9mhV+C8UymTHaBpeWXUuPNSqa/5ZxMuYLcGF37334j4QhaF6tFZfh8QbNnALysSXf8z4WegIGM3Wxso3Wgjty4nR7QYiDK7D0C4hUTnRdsULBIYvnxurDBgH/LosdWBVOJeEqXCIIm5mnR6rT/3nlUvI3+i6QRNIWwTE2YtH+nFA4cj90JJ7aDN6SmPPgD4HArVhgtu2EaTVF5pPfCMi5/G+mIrCJ/xfH6KnNUAQYFm3UgqThhuXVAOHSWDtJBLGip9DulXk35q4D+q4IUhHxapmoXigU5c7eVMZrVk01BtGKwvYo0ds78J1yo9sJMAYaM+Wm8xFk40VIb+XMQpjLw1Q9JnnYRnQxBT/WmMN0PNVfycmU1Xd5+rbpzxN63RJ6h6lbO/TWrtLDveA8d4I4m2gtrKTA3pxHNdBrp627PTPBwge+noYE4/fNB47NDnf1aapLYDF/mW4KaSq0AbYg8Z254K5TRHWtQIGRURxMWpMs/MIPuqFUAsW2MdDBygTCnvWD2THVYCNV+5isqH6tbky2O2wyshh7ZE0f20gob4Zo4CitA8IZ5l3c7NkmRR8YK5saB1jzF6N+U9iSv4WLEqRofLb7g6XiqAjOb9ykkLFQlJIbxHW0rVK+Fr3TtBhPmx7mI9h+tx9oOFMEQ0/LInoV
 H2oGB/wx
 ZXn9lc4Xqr5t2Uj1YGZmP/KpM2K2dGOB2zuyEDg1/vbZzRXbtz+mBGr1sL/tkxZQFcsRgvSqPV3U/dKU1bt6cxmTlhcHnGkMjp8DfW7EaLvpd8lPO7plwXQFEigc9Qs4L995MMEenrBZlCprCt8vxcIjNkhk8cGeCxW8e9OO8g5xjKwpBFRhee5EyIUJkpWDOFgP3EDomjmzkTb9ioKDFXd3TX3tjwmAopcdOGlzyyYlRFE5J3YXTX5NFMMfbXe2ks5ykrUmT1QLDN08MyZebqM1ZEvRHJqAFdok0yZa4dTzm1Cl7B3tuPp5jGjdfkiRSOPfAmYGqq8kkCajz8dRz3D4VaS2m5BIgHOh41AclE/h0Pa+Lr//WuELnQ2r9n2QUURirbjDf7MndJr6xOFBRuvtAyyydRTbhoqj3Dh/z6Rmhtys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.11.25 17:18, Ankit Khushwaha wrote:
> Pointer arthemitic with 'void * addr' and 'ulong dest_alignment'
> triggers following warning:
> 
> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> false [-Wtautological-compare]
>   1035 |                 if (addr + c.dest_alignment < addr) {
>        |                                             ^
> 
> this warning is raised from clang version 20.1.8 (Fedora 20.1.8-4.fc42).
> 
> use 'void *tmp_addr' to do the pointer arthemitic.
> 
> Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

