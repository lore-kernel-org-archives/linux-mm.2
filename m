Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761E3E98DFF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CC06B0088; Mon, 23 Feb 2026 04:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA9F6B0089; Mon, 23 Feb 2026 04:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECD06B008A; Mon, 23 Feb 2026 04:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADA896B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:38:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 619111608FB
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:38:58 +0000 (UTC)
X-FDA: 84475222356.05.EB0123A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A3C5240003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:38:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WCIbS6Uo;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771839536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kr+1nly6HjwRHjmm0DS7mR6q6FMVSK4aJ9zM17O0MqM=;
	b=Y2P2OHGmoQ7Uedfi2UeiUY0Jm3Uaep0ay3krwFhfvjXYYlWSFkT/e6OhqjiRGdl4gTTcRS
	15BAnzxJewpTX8VWb+qelYeI4ybM92Om03GV7IoIuBLnBad9gwc+jQSPlx72ONmmiiVNED
	hc0QlmhyPwL/9VjOqB0tDFkAfauA3Mg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771839536; a=rsa-sha256;
	cv=none;
	b=KiIIMQ4U7WuHR1trJ/1UGrZ1roEbbZUTbDxOrdPlgeQltVr7GX2IxRH3JhPxBE0gX+YfK+
	kjdR0Ug5Sm0vSdu5DuDs0qvxPfLiaa2unUFd6TpEXJvjhieLsZ6XvJEZ9Xy3ksCEq3sIlg
	L2Ch5nwSIofysv+467NS//zyUYOqdkE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WCIbS6Uo;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07D866012A;
	Mon, 23 Feb 2026 09:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8289CC116C6;
	Mon, 23 Feb 2026 09:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771839535;
	bh=5WaSHOyxf8o8JIkYIHNkBbYYfMUiu9f8Sn5n8UMdebE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WCIbS6UofZDuAMyv34cd6s4hI/RdQvV9x7WgYKKNb2dhDS11pnMvTdGdZZd/I5m30
	 Ny6CRUBEmG8iMK2Vg0sJPGpScgn6H7zOrODdBRQlMAGNm4KpETpibYDV7nP3ROin/1
	 ZOONuE15dArk4LlkVFm3aiYdLlLc9+eyoCtqGIbuo8NWESXwFhztcHP3truTOoJIht
	 Y2jKwsgtLGI0G+T/9KyZFrPcLEqwr3dHG1rY2Gp/1fnxUcTmtIl7WxXGLwo2KVHAvs
	 p3Ns2RhXSYWLxI4nmB7dCTWuzIzbkRbHYTEwLqxS2ZuEcLEvSSPp7kvndFFAt95L6/
	 H1JqsLdMXuCFQ==
Message-ID: <efddf2e4-15b0-4fa0-b9eb-99b72c9b014f@kernel.org>
Date: Mon, 23 Feb 2026 10:38:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: selftests: Wrap madvise() to assert success
To: Ackerley Tng <ackerleytng@google.com>, kartikey406@gmail.com,
 seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: vannapurve@google.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 shy828301@gmail.com, stable@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ziy@nvidia.com
References: <cover.1771630983.git.ackerleytng@google.com>
 <455483ca29a3a3042efee0cf3bbd0e2548cbeb1c.1771630983.git.ackerleytng@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <455483ca29a3a3042efee0cf3bbd0e2548cbeb1c.1771630983.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: j5ud1bhpht6rhsesd5k3np4qnte7gqeg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A3C5240003
X-HE-Tag: 1771839536-884439
X-HE-Meta: U2FsdGVkX19aT9pxjSS4J1LlP8HVIKaxJo/Ke25yvdoAqpFf2qnt3VaLehrXDLDAbje8EXj++3qE0sRN2ljNjRNRnx7/gtC4j6U2AoqZitXCagRr9rDuUeEm1CO929/uPr9LOFjMornPIQ/aiqIRdW+OjBR+PxWQxhAXrPnUlSawnW2UL2hJ6PhSlV4iFQhcIeDpJg254yH7MOGqQmYcWUC5j7Px9OvLfME9pR8X+t1KwN5RDVFCkwjNxJnGbYWeDDZlnMCGG7ES85QSxqLbB8HYmrrGiprq6NVq6tb0Y8uN6zpETUPtZDYjj/FMU879GpjlndaJc1VKM03VZHVjdK9BOPYUa8LHFVqiLOBYW3iH7FfQ8pWxfxVdocZdEB/oVDaZuYyo8/BhAH8LGw6oKXbX9uNAqtV+4xWb3kZ83vyS2mWbJGb4jEZMTm+uLQ73oMG+Y0wczsHarbKoy1pyA8UAemnspylRuVUTODS2iUTcpTn3rEe2Sl9nQeTDmYeXkF1L4lgcKB74s7G+wHnMmn1l99BBj9HLZ1w7/2M6I7WbawzBZSzQGllbkYPQ+rOSRIxeGL06kviNR07zS40O+XffzIRIBkGVau/ZL7nahVz0bHkbHCFlJS7thUtuX6aEUhwmqUx436Z+1Bg3elVJK+73RKAeAAFgbinAdGLFu7dmicbeAz7+Zv7WYhu43Nsv4pM+DNfh9Ff89ItPR2YzCx1ull8lvIHXX+VJ6r1U3vLqz+bH9PCg0Lt3gHTM3TrZdGScHtEgMK0oJ1FJhQZeKWqP+dcy/UAkoMxO2TYi37MP2Ao3rrj2VzJpHA4HhVJ5m6P6tHFYw6QfFL9nggyG6LugYW54A23pMSpatOBb9BRlhyiN+89mV6mUKavF9Aenxz5Kcpk1o5OLuumiIe96/+vejR+gPLJ1/ptQpRgmEouOOF+VUANcESZIbCBi9XH8vj1OR9gpdHUhDePPOKz
 FSy83tG7
 9Eq9PTXjYdiHAV/3rvx7U/Xlst/ahYgPaSVSwBOtBlQia+U82n/BN0hRtFcG5ja6UlHkk1COeEXmNFfA066cRwsoXX8PEmg3GeudNYy7U8gs4u6gVpp21e9WCr0s1FU0p1t+0FsbKrjjTpFQJZLtWu2uGz6cfuNLWtQHgOwkQePuAyCKj75JdzbXK4tdhNDxgZo0K7tB9z3+iB1My1T6/3RSHb6La3MeK7gGQdcN+tgkS8JZgrXKVpbkTGcF729mkdfx+ctflGM87zkNPc5QJl3GGaFt2yRgw5o381ZplVEmpuzl0B+xXoSIanZMLAg0s56FyNCwdQx7GqKSX/phHKaqk59oelCacweMeHG7m6/cC2504FIUJgkVQkapphFpcx0wmZ641xR52PRigULy4ZRiIm01PaZdhLVqB2z7tVS4IqjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/21/26 00:54, Ackerley Tng wrote:
> Extend kvm_syscalls.h to wrap madvise() to assert success. This will be
> used in the next patch.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

