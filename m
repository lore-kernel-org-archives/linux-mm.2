Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BFDC79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DBF6B008A; Wed,  9 Sep 2026 02:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFB56B008C; Wed,  9 Sep 2026 02:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4A06B0092; Wed,  9 Sep 2026 02:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3CA6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9CF5140116
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:58:39 +0000 (UTC)
X-FDA: 85193320758.27.127109F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1FBFC20003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:58:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMrkjVgp;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788937118;
	b=50D55CGy2/MkB4Z3UNWPPc0bElrvrkX2EP65HrAM8l2ITHp1rkuHn8IiOQoNTRzizyYfVM
	TpHBaRCi6NlPpX5QM3xpPrs9ICDPhriAu7f8ektt9hm/pGXkF8KM29gYv97OFart+Xt+AW
	z/PVJDtV6WXG6t4dFFHfnMVu3QqQGfw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMrkjVgp;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788937118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqVLTnDYn66bK2YcqZfK0YLZ2dluSsDrOdyDou0m65A=;
	b=v3knu2B70+2t9J5kw0mfqNvYIXKiTpCsRuFh24R8QI9GFShYqZreA14I+LBhE/+WhtYiYn
	cyByovWWdjQqhWIOUjIfDQdDOZ5s1ZF8u89p7wmIhr6YpmtvqIta8HfJfYyy/Bqq6aqrAw
	SNEuHBr8srG9eCQhGpdtERUywHYoBCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C780601FE;
	Wed,  9 Sep 2026 06:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B080D1F00A3D;
	Wed,  9 Sep 2026 06:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788937117;
	bh=IqVLTnDYn66bK2YcqZfK0YLZ2dluSsDrOdyDou0m65A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fMrkjVgpFiPSguDCjRN3DHCdAH3a2In70srjXbI+JAYwfUX62P8hsZPd2kVEkeyMT
	 ppciAQQLOoiEMj1nm71D9UG3Pj92Z+lOzUrGGp26ZH2SFpWv4pnRHQ7n2v+3vTRY4C
	 mthRPk1QEDzNhBckcjx4e9AIERtNFGcQSHxfZr88=
Date: Tue, 8 Sep 2026 23:58:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v5 0/3] mm: khugepaged: fix tracepoint UAF
Message-Id: <20260908235836.43865421771074b81eadd127@linux-foundation.org>
In-Reply-To: <20260909025804.3233645-1-vernon2gm@gmail.com>
References: <20260909025804.3233645-1-vernon2gm@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1FBFC20003
X-Rspam-User: 
X-Stat-Signature: re8zo6bgnzc6o7ck1h7zhjpz6te8pocf
X-HE-Tag: 1788937117-71999
X-HE-Meta: U2FsdGVkX18H4oCiwsHr0s/YgrTQDBHIeJtCSLkXmH2RKzuw+vi6iTucr/wI2y6uQi5NEi/P3RXVJ3SXb+DGdxm/W7xZYC/qLDD5XAynPxD4Pat6Q8RTE4+2fm5sWG2llsqTHcvK10w2zKiBnYLKsXDSKKbQiTVWOnbNipo8UuY4xt4FlJl7H4MGoD0TRxhRMFG6GAD5Sht2K+uJcowzyOobzLhZ0ica/H3fHP5g/oT1u33gwH3m7zpKR+lYCYEXVfnVLHpbiaHcA60Kn4wYEqWvFjoT51opGVJweD0akgNz2aihGWEqr2EWGy7zwdlAIq7OzAlksSWicDzwOULX6Y0xND6QN0MOOYYKd0o+dr5jUD6rs5Yq8it1dNI95lA0BHMIp0DUcYjH/iJtFcVzRnHYonOEzPN3K09HUKyC6l12cfw9Bvx2VeuJefaPh9qyfqfGWlw6FS1QwIU/MMGtka9bOXSucPwy5TEyH0VKI0vj6kbSVoXPrzPeC7iUTVZBqwjH94OXzh67KOq8XJxL9Uun3qZuphZzV45+CO4lngNmF4CFEkw5jAgx3fXUzXMS1INHbKOPyG3QNcl0474Icevi+KorkSsvDD394MJ20Q1mBOiIVWOCJNMuHffAlX0hKA6JJG0i4n53pF2gJGoZrHxM06j/G9r8oUMrql71h916GFNPBXqrDvZq2EICSROnIwO1f1gbuDxPECrlAegv2xpNcKgDEnudgkE9s2o66YbSP9+TWAVkqRq61Ql/3vgWVoxet9mGhxnQ/j9D5M4uNCW2lAFb5M4PIY4ztbhRrP11iPUchs00H/lIPUgiW1lEIdqyoJjEMxwwPmJV5z/zQZ/zjsZmtvlrJZ8AQa6lI5JBW+95V9BJz71kbOn83T7Zxl6cCIFGafWv6WRFyCXQJTfWT/ctlhrMXSLTIer/PyiLxK5KhCsnDekCCjYJUwsOiJVp39rOP3q3Gm+w2Wh
 CvQHp7xA
 3GX7UO2YJXTu8WrJEJnPgk1ah3XDuyPlHfSfW4wM7NejqOYdoQsigmeBt2dcwxArp9PJd0PrNuxabcDtMYZVK4xc7H6rWKmYvoP4331xvWhKhElW15Ajn9WaWrAw4T46BAFASgSiL5ZUQdGowY9JL0mp9aR3FMvstgvqNeQuV2E3hkzJ0wHetrpp1PEkKYWvSDM4nqum9Rojv7DdUnSsooi1UCe0sksxWiGYCRiS5hmzTich3M3455vYZgIdJVsXZzNR8RoWooU/u0Mf6940GjMb2vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 10:58:00 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> The khugepaged tracepoints take a folio pointer and call folio_pfn(),
> but by then the folio may no longer be valid: freed after folio_put(),
> folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
> xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
> khugepaged as soon as the trace event is enabled; on other memory models
> it merely prints a bogus pfn.
> 
> Pass the pfn to the tracepoints directly, captured while the folio is
> still pinned, closing the use-after-free windows in
> mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
> mm_khugepaged_collapse_file().

Thanks, I've updated mm.git to this version.

> V4 -> V5:
> - Use a single trace statement.
> - Collect Acked-by.

Here's how v5 altered mm.git:


 mm/khugepaged.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -1790,13 +1790,10 @@ out_unmap:
 				       unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
-		trace_mm_khugepaged_scan_pmd(mm, -1, referenced, none_or_zero,
-					     SCAN_SUCCEED, unmapped);
-	} else {
-out:
-		trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
-					     none_or_zero, result, unmapped);
 	}
+out:
+	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
+				     none_or_zero, result, unmapped);
 	return result;
 }
 
@@ -2789,13 +2786,9 @@ static enum scan_result collapse_scan_fi
 		} else {
 			result = collapse_file(mm, addr, file, start, cc);
 		}
-		trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
-					      SCAN_SUCCEED);
-	} else {
-		trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
-					      swap, result);
 	}
 
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
 	return result;
 }
 
_


