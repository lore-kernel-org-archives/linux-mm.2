Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C961061B15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712586B0098; Mon, 30 Mar 2026 12:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E97A6B0099; Mon, 30 Mar 2026 12:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626E46B009B; Mon, 30 Mar 2026 12:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50C386B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:49:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA11459689
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:49:12 +0000 (UTC)
X-FDA: 84603314544.21.9C52282
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id F0D5B20008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:49:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aslyZRSX;
	spf=pass (imf03.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjMc2TP37NTvcpaLi6rzvPtjC4cgqr+xov6gCUdqdyM=;
	b=b/nzqGtvo2rxsGn5IaXofmHXTvB7Qsc2tFxVw7MYfVlTztlKt14mbe1Kavo6dD7xHEfzax
	Yq2w89Nm1PLq05UBBgLB1MAxUNAaVTQC5Xduwao0lPhipTTYVQHIBeEvG3wpP2M8U6pe7d
	hXUf/CASgQDHKtILzxms/rpl1jpM1uU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aslyZRSX;
	spf=pass (imf03.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889351; a=rsa-sha256;
	cv=none;
	b=dKPTrXgg1uDOYgIRZ0mYgNwCpp/x4jb+pF67ibhKcmUV2DG9BNu+zJdHMYQQSfGv3L0pIp
	z3TLxBZfU3MBxyuGeRVaRUqCLTudQ/RQQcyFJto5sm+dOQgFjYiy9Elctuqnhmc4G59MCv
	xFxojok6gGesZBLP2bNWdZmAKMuFE7Q=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b2591757fbso4755ad.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774889350; x=1775494150; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VjMc2TP37NTvcpaLi6rzvPtjC4cgqr+xov6gCUdqdyM=;
        b=aslyZRSXU5Nuj4zro0eO4ZpKBd67q2+6aNJd3MGDUpTWyDYgycrdWtf0GgwByR6F2S
         KP9xUkq1pFGTuFZBZQbQYc/ztgzogRqNwgqIEo3fU9SYM1EJsnsKvJneycoGW4C8ELtc
         dFKnBWl6oKRQi9kdmWeQpaQqCb5OA3fYHfTCMDr3LmGa0Ki9WPFlT7fYPoBVZyjlYVer
         9KD0eNguqF/RFwfUwaEWFvbtkXYsDj2tvPf3ZYKkfKHM60cVkWircsbiokoGvDLhQY1E
         kHP3K/DX6dNyKPDIp71St2mr7YQ3MVR8YOu1d8F1h/ohVPWw+NvnrJaXAeZ6ok37iSpw
         RZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889350; x=1775494150;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VjMc2TP37NTvcpaLi6rzvPtjC4cgqr+xov6gCUdqdyM=;
        b=ZFd/vFC3CugDRgKd8x8pxI/hfbp/MoHM1ySbT/QO3r40Z+8qaiBRpHSptlX1gc5S0z
         4ssS35Wp8UQjcanqXqvN8MyJCw8wKIZzo2rDGCG3F+uvz6ZcVmZudV/5MyhVATFdoTl6
         w4EUnW/LET2r+wQtRedM0rN49kTB2qGHo+irP+C3Pn5lNplzwbbDlrDLDuQmS2l/FD3D
         XiYRSARsXyT4owiRwzqmJpR/hTAMlkXHJhaCbkJ7Bsv4HU35UAQpmg5s43rAaKVow5+q
         IxN0kutKOjZrqOolepuWERVnwE6TtqcTGb8wQGyftEfl21cfYi5qzi12kNmK6wPxC8F3
         0diQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNpsOc5PmObRbANaIVO27umFNmsGSUro8SIpSI7fVP3xpPrHE49q1DD23WhejqAO9pVyWGEYR46A==@kvack.org
X-Gm-Message-State: AOJu0YwrdLSJITT1WS7BX+yoDGb1T+dy4ipApvMgMrbBoKam/PQ2DSPc
	wjKE/sjVGDjCNN2vbhrVEAlBbLIbEb3FxLw7OZ1oEeJMpqJFvnfI7AgsbeJOCULIHQ==
X-Gm-Gg: ATEYQzzj+cENxdl/iBkpNXqdnvLjlyrVvQowj69Fs2mN6l2sj3lJwtxMojdcmQ3d/Tu
	C6ATrt2zbXrQvAo7C8N5WNfzKknH5ggN4ngopYTgWFCyryLVOOjdhqsOwXRw60xXpEFBrGL46pU
	8wjl4EHVRngWeDvsN56ccgq92NOWHhmYnXGGvllbsIvcYG5WRsz97T8tHoKFY33fuYscjCIU1b2
	qXBo0aCYi8bd9rHMkx1QaA749G4pEr+huaVbrNL1+a6O5GQ3WDKDN/uUAR6PY8cItQfxgzSDj8U
	P7lxaAwKDWUFkXPVsvTf06bh18KPPT4cn6FAkUALQROpqLfP+Fjsai3BZS+kIIhtKLjsHwEFiiF
	f1aI4EJBNhddhax5k78aR+umnn1Ds5gr2iXOLlEnw3LJ3/EQ+P9pnqNHbL9zcoGbE337bI+EFUv
	SS4/wfBGCuC/LVZB3VpHFTLfuX5OSeuREm7qMJ4sP93A7k30wCPrEj7U1X9EXHCpBdgQZtdpAtQ
	QVbZW9HNg3kgdqT6YborpzyL6RYvC62IXqzOe1XCL41VD2uX9hcog==
X-Received: by 2002:a17:903:3c4c:b0:2b0:4d40:ce18 with SMTP id d9443c01a7336-2b241d3737bmr206495ad.14.1774889349384;
        Mon, 30 Mar 2026 09:49:09 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852] ([2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d9507d505sm7423298a91.10.2026.03.30.09.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:49:08 -0700 (PDT)
Date: Mon, 30 Mar 2026 09:49:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] lib/tests/slub_kunit: add a test case for
 {kmalloc,kfree}_nolock
In-Reply-To: <20260330120517.104743-3-harry@kernel.org>
Message-ID: <41823aa6-28e4-e57c-6a6e-fd6a8235462b@google.com>
References: <20260330120517.104743-1-harry@kernel.org> <20260330120517.104743-3-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0D5B20008
X-Stat-Signature: 3atur3pw19pfzuuuhswihkme1wndhnco
X-Rspam-User: 
X-HE-Tag: 1774889350-411036
X-HE-Meta: U2FsdGVkX194GOB3R0aS7fNe2eFh2aA9SKQs/1HEavwtHo/JX+EcVXWq7oTM7c7eGddptOiVXyzV3MLyqCOBWwsOX+7wDCZo49Hs68tt8jWMLgHi+ngYvuZpNYPn+nPpvjtYGCAI772hnpVx0YH/e8Nd6pXOQcSHzDYdaoQpgFfBLIKAT3w8itnRmSBzBo1BUDYBz7xi+Q41SSHCrm8K+FGEhdc3lbfHpMb74OtWdY4E5DbhOVDkcHTSP5dXFqKXgUdKqwRTAaCHTTDyxZdeNYuQQFTYoaGSqxSi+Buyy6z4NHUya0xMt7Sd1FOV0YYgCasTOlazyjpCb0Q9xhR/s84ieItTFhzlj+sBOiIXwXv3sMm/cAiOygtIw9pvNpslctTKuWUubmusMo3PSoCiNT7VUxMeW4ljk09FN7uPstvhmi1aa2A884bh2fAGBDJDMdRxU4/b4sdQy1J19lYkFxhu/GPGln61k8Pmt0CDk33oAyTO6VG7ewCV37Ty9l9ZyiqW/pE1WEkN5xf7UdSlqMdgMq92ffhkoo4Zp9xwOK/NxR+RQBlUhAhirpHLtnMgO+gm3oaH0OpahP1Ue7fQk4WozuiNp8S/fQej8z7cQEz8m/aGdA3jD3Frgn8smRwSSn6AYIJN8vaArCbEWH3g4yCGDF+Dkczs84l0b33WtI5Bt093kxWiMWBsXejRCrQTpyWsUEQc7BXZ4QDiInRdPJCv1YBJrpyQNbNMI0epcG0ETeQwzydxMZxnKmz0DsnLHkzoqC5HHdiFvSBeBVV4zMAo3zafGWKVymUY3T5uK1kPZgkgwxo67B7dGJNOCRjFoEJqo8btuH+i2+hEjfgiofcuA0AxCGzqpuuHKwsqjfqCiHKu+M6+eZfpdTZbaWi3rFfKqs/lgdnrw5HZb2S3fixGH+9b1V+AKPK6EhQWOBcXjWCotZ6em9f170zxg7f6pbMxUN3ljbNWwgqDOse
 VZDTvd/q
 KN8fabYUgQobnTEe+sfl+WwBMxY+ysWL+6UFRj7Lp7UCpsgeFy5jbyx5Eprw9NrPvOWIzGmwFSgUcuYShp3sRVOiWdE6eMrovh5WwgLZaNtYzJd9zPry+dPgxg3FIblw48BuzRLQr8Xl9ujNbFzLmqwIhlj4YjwKDZ83VsPE8JkCKLQ5YJRAni5R/IaiH0G1bsp7j2AM+Jm1hOOgRWyEcMVPKP5NoX5vTuNlQDkPhN6fdbRUJtSUzg5fZXNSyva4g9aH/6AnMYt4GIAwJUM7iat9hsdDopT0bmjDqvg0zW04tjpLsRwIofsjThbIOZEL3CsuGAms/pdf4SR552eYwH7GjWm8D8dqFkKEEYHQCiIf0yfv2TIPCrFL2zYMuqosYOKLfizvg0yBinLMF1AV/h3kNaE6xsVl3Z1vuvq7h9aJomGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026, Harry Yoo (Oracle) wrote:

> Testing invocation of {kmalloc,kfree}_nolock() during kmalloc() or
> kfree() is tricky, and it is even harder to ensure that slowpaths are
> properly tested. Lack of such testing has led to late discovery of
> the bug fixed by commit a1e244a9f177 ("mm/slab: use prandom if
> !allow_spin").
> 
> Add a slub_kunit test that allocates and frees objects in a tight loop
> while a perf event triggers NMIs on the same task, invoking
> {kmalloc,kfree}_nolock() from the NMI handler.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

