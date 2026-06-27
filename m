Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C35FDC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 13:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81BEC6B0093; Sat, 27 Jun 2026 09:41:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCB36B0095; Sat, 27 Jun 2026 09:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDF86B0096; Sat, 27 Jun 2026 09:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45C736B0093
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:41:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C57721C3ECC
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:41:47 +0000 (UTC)
X-FDA: 84925805454.19.1265105
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D209216000C
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:41:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=at1Y7I+a;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782567706;
	b=4dA72IwkyDy9MKZ1bhdhcqpVt4Ih241vkshycU/C8GAPi32WvrrzzKQQnMK993HQoUC986
	Lt99PlNgiJsoeVj9vs326EVTIEDktctzCY0Zcxbd/fMND+DPvjvvqHX2X6xB9sx2Pc4iuZ
	POPy7kVwcPlWAFjpyXE3BWorw23+fFw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782567706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UF6dkejka5j2KkiJuz1xADphh+QJ/qSN8zOD4G/jpU=;
	b=dLdxo6TWbGo2n4mxe8T8EVP4KwKtDOz4AAB9iVbwfSpBBh24RUHJ4GBkTkdKrqY9nSxzeY
	eMw/zMYAdkmEN/7Ub6SymbovVlYsMOLRW8lPIBDWuiZAE7eWY8W6SFhVXJMftGJ/pMXk9+
	IyhapcxqoXpj8LG1w9uRqR69Fpv5thc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=at1Y7I+a;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 316C235BB;
	Sat, 27 Jun 2026 06:41:40 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C12093F632;
	Sat, 27 Jun 2026 06:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782567704; bh=6JnPrzRcA7hou/7+sISrnCxvj9WqhGxmMe38PFGL+60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=at1Y7I+af8DowHuuB+q7l9RltrFaqIV6FTcFuGNWudFdFpHoZh8YbAxlcKM3OICdE
	 uBFiBV0dAyTlY4/scGH4rEZbbNagbZrrQq35tpNi0rA4HYLuDR9incSHuOiUXypEpa
	 EyiiAoxolA00H4b3svQV4O75gwTw4jBHwJu/W7Rc=
Date: Sat, 27 Jun 2026 14:41:41 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, oleg@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: skip the remaining scan phases when
 interrupted
Message-ID: <aj_TFZEniVULJKQ4@arm.com>
References: <20260626-kmemleak_improve-v1-1-d40c7616f64f@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626-kmemleak_improve-v1-1-d40c7616f64f@debian.org>
X-Rspamd-Queue-Id: D209216000C
X-Stat-Signature: 4uqeenaw4m3jcnt7kcs7wat7rhhyc7sf
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782567705-903223
X-HE-Meta: U2FsdGVkX19ZfRv5RiU8BISKALX1B7wfiTa21Ocxe0W3ZKVzeKnmUr0Wkf1a/KSe5gu4tstMAj75kdFrIziaEwXw1Yv+2CSRPyjOgfwm1r9Qx6cIroS4SRQVLqAaERXxGbGPZGIVgyQ7demE++E4Q1FyXbUi+pwpI3sVjUF6Zbza7qYIiy5Vkkha+rUYjIwKg3fSXL3gXEs4KKH694efZlfPhL+1SXDLeGVUfiSVa2KOwNLoVmNqduK9OUkl6AJuH6Ltj2M4o3qhKW3VRPiUSVsJ+84MmWZdGwGie7pXsNXJYuThtQLj0+1dXBd6NxxyFNZE1pDwWdoQZanXa9CCWOCZFMOzozW2S8VoRvYGWP188BagDruUNXEVan20ukXkUD/QFZ6pFImwLWPCpK46jyOTBXh5exySbLlKNhnFEnCg6z/FCGqOk1+0ez0JU+DO9XxuFyrKqOeYYaOYtoO5VUXyPMUSHiTdWfU2o5pUGqUhihZ3hlzKwD3Eg9SlEtIxZCsm9aYsWx2/YleD3Vyoq17ZT8jiSJbttMZsjN44PWmkEpeA6RRfYLWqyF9ch4mEo4fGLITYt4xgfEyq8TGcIkEqIaM9tGx1juKq6AYD4rk/oh7crLCwG19cGdnM3Om/E1xkuoE3byp4r6tfST2ImzlK4DuzoMgvjSOcjuLmWc8l8upDhlMRCetbADTRO+gGww9R5ZNF9oRRV/fZjp0cWYp5wmX1Rd+jAelxuDMNoQJyDbmUdB1Zs/UdV5KJgU5oL2emoTDdRIqL36bPXDOHF9ZZphxsJq46qJvG3L2oWSQioByAuYvQo1h2YOW+a+NxQedKbzCo+4/3W6/YEI3Ah2vZMEl8tZZblVS/M8I7AyWuw8n0DCKnAHUM1gQEgiGxyVc6utugPBR2HjR1+v21dM22AtTa/0/Fvq/bRpUQq9mSRzZmmzUKdmhs+Gfa76sczL+kwcL4JztrVC0oXe3
 DS40RfEj
 RtYQI3tJo/G2P6y9VKQLwp/vTVoTsMKeNxhII9fe45OVLUZEQEhtw7ak8t4U7pyTHKvvyugFy18pBkv8K1MCjrZaV10JCR5BFp6K8CdS94Fj/n8rNOtpELGIpxpejUK9wABJ+XAnXluWIqVVmIOS0TM1nZai852qGFeVBMyS/lM3bf9FFqqXGjwhbBUt6Ty8MRjqf4rCH2RHQbbfRQhD8tYxlmDYGJKRsdb0i6f84AntB0GIL5d5seqJ9X2HcTLuC7kRuQ+bWYB7W523JkJl5ixwDvP31goZz+0mrdjrVdDoLCGH2cUQE5bOfRUfza24CG1sf7bQVfUgw6tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:56:23AM -0700, Breno Leitao wrote:
> kmemleak_scan() scans the per-cpu sections, the struct page ranges and
> the task stacks in sequence. Each loop now bails out once scan_block()
> reports the scan was interrupted, but the later phases are still entered
> and only bail on their first scan_block() call.
> 
> Jump straight to the gray list scan once a phase reports an interrupted
> scan, so the remaining scan phases are not entered at all. This does not
> change the scan results, it only avoids the pointless re-entry.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

