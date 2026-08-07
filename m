Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2F0C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8266B0092; Fri,  7 Aug 2026 11:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8901A6B0093; Fri,  7 Aug 2026 11:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F326B0095; Fri,  7 Aug 2026 11:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5706A6B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:33:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2846A0438
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:33:08 +0000 (UTC)
X-FDA: 85074866856.12.E6B8AB9
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 299C02000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:33:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q1OPDL1U;
	spf=pass (imf31.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786116787;
	b=ezWIDFRjU33gTw7M1Df8/hG/mxYI8ef2bB8xsL0sSBrG73fAF3gCa6G2E9B0Yh8w4tB8jE
	YiSZRKJhzSmC8e6gue792wqoIYHcKaT3w6ssKCsVuJ46NwGTdkGFOsR33iPzPUnafqqIAG
	M29cAxrWkUb3L3BiFY7EIa2BW2fV2SY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q1OPDL1U;
	spf=pass (imf31.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786116787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJwt5k3XIuCNfIaABMjN+sqzVrB1/2+kCK+tyfxVrvo=;
	b=kl41S0KVJiCdLmSvlogslcWI2Ja79oIEhw9qN3PuVMAXRY8eo1psj7CLXIQw5wDXFgYtMQ
	8ESJcH5AfLrjDZfAKsP15XsLyN3HfiRUizTcePLX0P4AGoZHC7abDGSczrWiJLQheuEFzk
	1q9nuuvIy2zx4p0EkAOxwfKrmz0baR4=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cacef7d299so106065ad.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786116786; x=1786721586; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nJwt5k3XIuCNfIaABMjN+sqzVrB1/2+kCK+tyfxVrvo=;
        b=q1OPDL1UiMau9Qnmh8GelBbARXJuUaErVRp8Ie1ruArfjYIN46TAYotCfHXVkyMBJ9
         gJlAFMZpb4LalmI8aB7txjsFRtODMn7zghlOhybxoJTAiSuRHVa0DABHXlFO6I/6X1S7
         yk2JHHDWFbSrYPLjhqwpQHLT/MJUxXXNT+olEm5ZFiy4B1p4ekx7C8psxqwOsJVoLKox
         CNlybs9iO3bfXfvZrTPm5rBrC+CT8Kc6PGnhInZh++3G56IPI1tOqdVECMXhdHTlCB+F
         1rzRwgm2yy7ralGXJx8V8c1b+1Fdb5kfePZM7hmVL86d0pQDney69R5HLb22wLOnAex2
         1xSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786116786; x=1786721586;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJwt5k3XIuCNfIaABMjN+sqzVrB1/2+kCK+tyfxVrvo=;
        b=GiWvT+3hUsvVMhNTjAzC+IrGi3+YPCWqKxhqfIytns2mEhEwtLihdrpVFjLfOBlHMD
         WJGfczCrIJOMB428Ysb3VyxESoqpLkZwSHXdGkCYFRFu9/KaCNFr8xsigOKDdqCwzICK
         Dq361o06Us9E6u49hAxM9nPxTVaAhY2oHl6r4P8hK/rNBaIEwOx2rrMs1Y99ZzV8iEcg
         NxkXcmdTX1htimTedpQajtg7o8kRLq/fzQ+qvRJDmaA6iGwBolwnH4N4VnqNXcMZb149
         n8+afm7ndlzImbCuzFuSCh4f30x7+Aw0AbxlDXrBE5Nb4hrNL56nL4ybn0xVdch499Q0
         YDkQ==
X-Forwarded-Encrypted: i=1; AHgh+RrrT7b63E/S5dII7EdMZG80Io4Y+TBw+FiOBqY6yhrqtKqRslx/mpiQnacwZglgQJbrYpUwOX2Tmw==@kvack.org
X-Gm-Message-State: AOJu0YzJHnDdciiCvfdMi85fxeOUrLTiRSNqjE99C8CLdcy+NfpwIgQr
	Rr91vzPiWbX46Pl8LO31SpU5LG3ShWiHK+TxmGLxSlajzMSQkiBoSgxJfkcBqrFZiFOGsvXNsci
	v5theg/Qf
X-Gm-Gg: AR+sD13vIDJJtvVMCC760bVi8rXjE5z4OKjTpnbrip9BhzNs117MI8vjky4PEbePbCn
	0iqaLO2vW6UnXFCHvcCoX+ASLYrOVrBhxZWXrUxpXAmzejx4XWIV/sps7mjLNDRd1UIYlZcV7iH
	czm9tF/uLIjkaQV7EKy4i/EkT63tj54xnBgM9i0bu1uGcv8fpx7d6lmdRtukYYZEnMrv15DWbO2
	iawQVNJ6+rWhRvv8kId4RdBXLuMFE8XjP+n4o5RwLlnpdea9KcUc+6S8CxJ4BD6q10cW1PTaz3W
	F4MlQevx0oH7ksJgtddYW6oPjvTQm/tnt64ItXVPuV9rdY65Ls7NIMlP3Lrz6vt/4P2eHXc++ZD
	pfmRPbTosI0JAJc7E0uRgPVxpyS0rVbzMbBDo+lC1i6kcJy2b5d93hEyTAhNK/zl8sh/hmLf8zz
	eky+ovqCdaLX13+Uzd+L4G0y80ajyAbPkpBMXeuGlSt5/Iz+WBHCpQdwcBLeH/Ze140kYCeZVlo
	5chQei8nuigThoNPNt3iwnbRyonq7B8sLURH247NXmJa7ix22l0qgndpB70d94UIyEyjLiUPiWo
	4XDIn2CWrtqHrhQ=
X-Received: by 2002:a17:902:d983:b0:2ca:cbe5:c3af with SMTP id d9443c01a7336-2d1c47c4bb3mr6864195ad.7.1786116785364;
        Fri, 07 Aug 2026 08:33:05 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:6d4e:7aad:e9db:521b] ([2a00:79e0:2eb4:9:6d4e:7aad:e9db:521b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390b370b145sm1390228a91.2.2026.08.07.08.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 08:33:04 -0700 (PDT)
Date: Fri, 7 Aug 2026 08:33:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch v2] lib: test_vmstat: add synthetic benchmark for vm
 stats
In-Reply-To: <94068447-f9c5-ba84-73be-bf492277b9b3@google.com>
Message-ID: <a06d4920-a63d-d653-1ca2-41b7500f1134@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com> <e8dd28ab-ea7f-2ccf-c89e-a12f2d8b9988@google.com> <94068447-f9c5-ba84-73be-bf492277b9b3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 299C02000E
X-Stat-Signature: tkfdh8wg3hxaefwxz3b5871xawjes3uc
X-Rspam-User: 
X-HE-Tag: 1786116787-240162
X-HE-Meta: U2FsdGVkX18iBOAQtO2eWMbhuNL4TsLCnqHXNMYnD0CzU/GmPJN15vJ8ZaDOJkfUwU+qP9JIIdFWhlGSjRo+zt/Hbr6vtsB+xhxqYjUDi3/ABLk91WEw3f7zAIDBBXseBPvMSbXNVaPvdusT/jMjXo65lZ8YMqgTUIbBM4CXuQMuOLPWqH3yBtEHVFltDgK3XyV/ImFWHwITbcB7G+nzAcHGuQS144Ni9XLg18RnXc1UqUpDqJVJLw0KIC5aehlEhs9Xn+6OMExdILJ2SFOn+SREuoRpVKCSW6enVbxPpA+lLiRW/2PyFfilTWTvU5itEW7NMBlR/qIMY00Eo4P/vnKucDM/L6f9YLxojMrNSBC378ZMIYz86GpxBnVdpRzLPPUND4b9rAKbVr3IVtHKnK9DC/lz6jtF2mOTK8Ady6L+1POSrKSW7eoXt1XDOGIcCn/f0JlWFZww+YH/6qUR2svSIM2RdHRmj6V+kywL+SRYRXHRF+3OcpB1JXn10C96ogH9a7LXGFZNFkI2MMRtTH6f9DPxkFJ5WiQVfYYV6rHdmJ37EPWbPPQcsrBkX/hbIk/8CLaK919Y+/GVY0NEuKYmG1jJQl8JEvQyfyyipyZAUd7ZLHmAE4dNl6MRPnQA3ycMXxA9fuT2LomIbMqG73aOhG3FqOXm6o7NkNMW60iIva10N/tAQrgVtpZ2WcIWpMhaNhW3SFm6+Jf9rhLvB442U+AlJIuMTZSnCUpMvWy7MU337hBj+WGiD6i3l64rOdv2qphcPaCQdNrNwAIMMkqWVl7OIBiQwgAsGMcHclMwy8wiX2elLKYMplVbV1DtSmN/9uI/AqoyTGUpkCgzqfAA896XqELmgjp+NfxMNPPl3L77ZWgNWNXIJ24VwhyyRSoNCroTQfPJr1OPajx2CBgDfqjZSvByIvDJVezDRpunT22bspaEp7B2ZSaGkBNjE6+xq9aoIvCSl15bDT1
 6j11cqJ7
 86sYzTQActqUO2ldLCAbPM83HLV9i5cLjUMKfLUb4ZpOUqiIqvmeZ/RbwJ5JHlvJLvF6SqN7E+k/EV1ADFclUPLkLr7t+bYtGAPv3B5wR4y94oSXyyuZv84bw95yWOGbV8hv61W/XQK47+VuOd5QcVAmoUOFBIKP2vvhn9hRPHY9x0ZsKvDcbFlNTCtYnclCLRbCIF9aphuaFHPr5cQ7n2W2zHHbOMX3TQzk8g1kuKSLsljaAPsZcSrYNjvsNu06w9i15rP7l/2I0k7266InttZl1UgpmtkDvf+DvybId9nu2dTaFs1wd09u/XNsvg3nfT4wJmEfaVFgUdk16r1gCmM4LXB0V9SMMkFwb6puIMFto/IlZ+lOQzBzG1KGti8RMQS+DKAoJShnV25ZyGgsxBxSc/qN3WEuyg80A8IY3xlOvo3rYZXZxIQJPywd0iYeU+opyK3LVGUCYUSFbkzlHrkYvcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Aug 2026, David Rientjes wrote:

> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of VM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> The test is run by inserting the module: modprobe test_vmstat
> The module insertion will always fail so that it is automatically
> unloaded; the results are in the kernel log.
> 
> Signed-off-by: Christoph Lameter <cl@gentwo.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  v2:
>   - added bash wrapper to ksft per David
>   - integrated into ksft
>   - added MAINTAINERS entry per David
>   - fixed alloc_page() error code per Usama
> 
>  Adding single test for now to solicit feedback before updating the other
>  two.
> 

Any feedback for this one?  If this one looks good then I can also apply 
the same treatment for test_pagealloc and test_slab.

