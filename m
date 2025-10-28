Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763BECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 22:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735C68E0005; Tue, 28 Oct 2025 18:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6B98E0015; Tue, 28 Oct 2025 18:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628F68E0005; Tue, 28 Oct 2025 18:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4907D8E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:34:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B08AA59BBB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:34:19 +0000 (UTC)
X-FDA: 84048977838.22.8E4C2A6
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id EDA55140006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:34:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YLQg+gN4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 36EQBaQsKCMUlnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36EQBaQsKCMUlnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761690858; a=rsa-sha256;
	cv=none;
	b=x4lADK86G1tNn1PhIPK8svWX6PqGnNSp8I0q99tVKOoE+BFbi9uUUNAZpxb3FX0wikHtpe
	f7dnbGNYMkScX+/BU7kk3e8I0hQITW2WQvEe423a4dDAcd0+0YbsC2A1+o+JC7YYG8FHJ5
	XGJDtzaETy/0YUaNzcEuKprrlcntE24=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YLQg+gN4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 36EQBaQsKCMUlnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36EQBaQsKCMUlnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761690858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=82B/e5OUffQkDxAP5PsiVgukJ2nGDysFGKTvJ7FhReA=;
	b=A7AovEiNas5kMl/Zebm9SDt+H6l5NzSodoI6BIZ+1CqAZ/4LWC/ZbveGiKx5vw7Ipk9SEK
	mB6ybpyUKWhws3x7dfp9u2932RqmFZIaVn1+aUfFv0zrZN4T1OFA0ftj6oj9m/ad61Dou0
	qyNYZ10eXrv+Ku8O9fQ0RLjwMJgv3is=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-782063922ceso5389463b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761690857; x=1762295657; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=82B/e5OUffQkDxAP5PsiVgukJ2nGDysFGKTvJ7FhReA=;
        b=YLQg+gN43wHxwmYBQCAUEmSdHb6XlzUZDvYkbMqk1vtze3SjPrR+XBqVqE/iGRLxCh
         LuSDlE1VPuRH8fCPoysDTIFGiMlV5ddniF/w2aOKL9nCbhzmkwvyHUTcN9O8n6EHdpiP
         WMcFReI37Vb7Jwfi/hfE1Tfspgmcin02zv4kUtZ7HOBOUTQe1GUZTN5FwVYl5JGvFlGW
         hw/I3firLL29Tme9aKop9VJTRc/nrn/TQEZ5+dYoogRcuNlPPYxnlvNAMsDWIa+uB9Pt
         opXvwoDA/WU/nt71iFvU5bf8xNaEb9tBpXS4q0VIr65ubSJA+QIoQzK24s3134AiRabX
         dAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761690857; x=1762295657;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=82B/e5OUffQkDxAP5PsiVgukJ2nGDysFGKTvJ7FhReA=;
        b=s4T2bhzHDhkNPqymCiQ8zOMsO3yFTcs39g5ioLCtml9g8bgpaD3oZ6/Z3VR2JpuZDM
         TscpRP04KUzqWHTfcrsbeLx2mXfgANcdmakoArVjxKr1yWZYWtOsqorBdStHN0ZweqCH
         +q2368+BzlzDWE/RpltSeux27mRb6PombIYLJb3sKlCiUi4PaTq280Fr0q/fMAYOp7vp
         dyXJReKsBPxqkif93sXVM9gWK4FpmADRQvuE1qEb2K/LuPmC8DxeDz/PtxIf9PQbZHWM
         YqSYq8dXH2Cr/v9iGk1NSO7PM5oRfpjyguEVgSYetlyqHXZuECJzSkJ139DGd6hs+pxi
         boSw==
X-Forwarded-Encrypted: i=1; AJvYcCWGhhjpKS87PF8LgdMrmqbAVs1XjyRaK7jEPRrDrU5YA7qrXoHJWa4Iq9Kj3sTKcPoVzAURukRktg==@kvack.org
X-Gm-Message-State: AOJu0YwJFQfByu/DqR0Qn1XeaC4qUlAXUMSeInMPzC5Y32+Qwbk/WrAt
	Wmj42T4vD4szGEMG14WYX0niYE7Mwg5kLLTJangWG1J3hkl3p3ogPyTmH6eyueJU8IzZ+JE7GN/
	VsyUz4QpyTQiOlk4RCveOt0YRAQ==
X-Google-Smtp-Source: AGHT+IF/qfPNoL6JkiLjO359CkzK4oS1vbBtwFq+LTrilAHtRFpRVvqvS8ZuclUXWTGo1CNzmGf9dAahO2M+QJlTeQ==
X-Received: from pjph17.prod.google.com ([2002:a17:90a:9c11:b0:32d:7097:81f1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:12c9:b0:334:a784:3046 with SMTP id adf61e73a8af0-34653146b07mr765020637.38.1761690856743;
 Tue, 28 Oct 2025 15:34:16 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:34:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251028223414.299268-1-ackerleytng@google.com>
Subject: Hit an assertion within lib/xarray.c from lib/test_xarray.c, would
 like help debugging
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDA55140006
X-Stat-Signature: 6wec31ugizto46cgt3bys5t5sqetxd6e
X-HE-Tag: 1761690857-843380
X-HE-Meta: U2FsdGVkX1/ATTZutkoRI2PsFStxDZAumAnoVc+RBb3p4pBnxjEHWMaJHvlQReSTAcG1SMZWdC2dkuTx0jSptawrqFJdl5WdwC1ODtF1avjrfeKkDxe5Cc0WdtgwFSzDqzpBq5y8F9puBOUnNbq7l90JdLk0DGEmO3tMus3qOkFO0IQLD/S0IXmvgxadAD2uwbyqr/2/dkYAO6yDmebNDvvJ27CAjE5cTPyrhq+XFX79LO1rgpSSyqDHN5HOPH3DNzhAL9vgHk5ILYk0KTFlphGh4FvrVzwLfQTg+Vx1MGYai1EQrNPi4Y7V4THE7pqvOh6HCoBOLWQBxyBSCA5VH0OniXDZnjFfZgWRxE4kq4ICEiETChzsIXkQv7KgczAJJE/q7cjL+OI5JUjj8ZxYG/uWOT6kpKJLJVA07mEi5NH8S+sqD0wwLePbQtz03joc3dmqXT/mYu3XUXxZ2lV0OSAI1KW2m/s3Xe9hwvJi2lSpEzsOaauOSmSgUB9i64j2/e+vxXOSUKzzc0Z2l8RGhXSYQfWMzHhBwgidwf8E0BS+XV7VZ+YxM1U2NN7dNsKa0e2NvL0uPhu8gn0Ssr1kPS68ajBg8sLOtrDVmc51Re3fxpI5yGUlIfjceaQlqgiOyyHtFxQhy68BdEdLpT0TkZHB+hGfcIEanaqlg2Sfe/4iK8BZZe0a146ic7VAOHfLvwKfF2MOlrRhL/gYfJ/WxCotjBcY5PKVJvlKboG1ry0eM7mcsg72mJhNkfdD/bO88XvuL84eV8kz46jOltvwqhKu5goZhjTRPxQ66DCVFk30wN9puMgXtAIVcVzmF3f5FMVqTLAWKbmpyqUY3EZEQQvGwZ2LdhzP7tB43LB5loE6DQSH7hfe29KX9rfxtWqvfK+klb2VFGeUI/dZ6fw2BOnOCYXv3dcyz1cVwvpy/FkKNiCJotfp3b/bLW4Rz6AumHIRm6od4ZNGrQxNJWN
 wKof7JRB
 c1AxuHpHTMZSUctQ14E5RYNg5MixZqv45S54/ok5th3bm6V4ytCgGeLy0OAoW8sJZXdL6nCosC+2LVJPfN6ZpsChdF0mUpdg3KxMBPURpdluEU/45BfXpfwXTqb8IZwxABp5WiJC5F4fySDC3LZEz9oBpPfYmJegAcNobJJA7tvAyYt0WIBMgeoNKwRiLZSd4HgUwUSVz4i98uFP+aOmVtkzd3RkZ3/584+KdXFJPz+sWJ9KJcN1WAX0cqqcShVLEytKBhXsQvZwE2vY08MfDwq1iAPCjkZL77ccsYfLeLomi5se0p74gZ5BTqgbBj8iIURx887Kkm4a6UDZYMRAXpp+tbc+JlmN4t6Zx1Fekx0KIE4tqApxSwoMSnAejIDIbLiM6iTiawoysxHIl6DJnFvsy0FBlwIgHc5Cc+jSDB7p2L6sm2I9Rtd77TdGlNHt3A6oZ1Abm8MC9CyOulxA7w0j5XSG+zpy1tpd+RSROM2rN4Y8CKKPXnTxU8GaBekFklkKRgBYnP0rJ4liwJN23oyc7p+2nFvcsw7Gwzb0+OeKNyiLl2cfM1SpUvy9wec71BzEyqrgAOlmilkmfgXixkXPQl0+bJsG9AKVt8EXGC4MWSp1y+S0iFXnhceen8qViqmKE18jvG6cs//c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

I'm trying to use multi-index xarrays and I was experimenting with
test_xarray.c.

I'm trying to use xa_erase() on every index after splitting the entry in the
xarray. (and I commented out every other test case just to focus on this test)

Should erasing every index within the xarray after splitting be a supported use
case?

Here's the diff:

  diff --git i/lib/test_xarray.c w/lib/test_xarray.c
  index 5ca0aefee9aa5..fe74f44bbbd92 100644
  --- i/lib/test_xarray.c
  +++ w/lib/test_xarray.c
  @@ -1868,6 +1868,9 @@ static void check_split_1(struct xarray *xa, unsigned long index,
   	rcu_read_unlock();
   	XA_BUG_ON(xa, found != 1 << (order - new_order));

  +	for (i = 0; i < (1 << order); i++)
  +		xa_erase(xa, index + i);
  +
   	xa_destroy(xa);
  }

And made a call to

  check_split_1(xa, 0, 3, 2);

Here's the assertion I hit:

  node 0x7c4de89e01c0x offset 0 parent 0x7c4de89e0100x shift 0 count 4 values 254 array 0x55edd2dd8940x list 0x7c4de89e01d8x 0x7c4de89e01d8x marks 0 10 0
  xarray: ../shared/../../../lib/xarray.c:764: update_node: Assertion `!(1)' failed.


I think I've narrowed down the issue to the for (;;) loop in xas_store(), which
I believe isn't counting the `values` to be updated in update_node() correctly.

Is `values += !xa_is_value(first) - !value;` intended to compute the increase in
number of values with replacement of every slot being iterated by the new entry?

Why does the computation of `count` involve next and entry, and why does the
computation for `values` only statically depend on the initial value of entry,
and on first instead of next?

Thanks,


Ackerley

