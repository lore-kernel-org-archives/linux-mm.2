Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6795C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E136B0098; Mon,  7 Sep 2026 17:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65C26B0099; Mon,  7 Sep 2026 17:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54D36B009B; Mon,  7 Sep 2026 17:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4F36B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:01:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14D251602D6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:01:57 +0000 (UTC)
X-FDA: 85188188274.06.48099A4
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E81FC0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:01:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ouIU0eUS;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788814915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGJyWqg8b9I8pDWEAS1fAo54dmwDkCp8//1b4QCLnMM=;
	b=1IzjyJT1kLPzRSMscbXTLMwJQgD9NQhB87jmwW2n6S98CnljKBzWyQvjIMLcylVQVEqVHc
	J3dnq1KjMwLlwP7W/u7Wzq3qvGkMZna9eRU8VaSfvlb2HEYenPMhoZMLz9nqUxv2Ox0qI3
	yytpWazKTtYmUJ+758N0SgqU0zZoNSQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ouIU0eUS;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788814915;
	b=7oqUAFo1pAygS8pMpFWNgdvHFx/te+JfD3+b1jwFbTEa6+oTqU+2B2L1sbUuIl8dtU+nV7
	6S+1/aKfqwWGI1vmJs+2+D+f97W/3sCN6aX7H7/6RH4pW7pk0Gc0VInum/ynZMn/CJNuiT
	jIuDFHcYi0cHldJCUdbSzkUORAwWtQM=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db425c9050so120455ad.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788814914; x=1789419714; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TGJyWqg8b9I8pDWEAS1fAo54dmwDkCp8//1b4QCLnMM=;
        b=ouIU0eUSNRklR7AO/uaXiJEMIC5XDBXoXoUrwLJU4IhSnhD2tFojQzgQYOPnKCRJYL
         sjS0w40tSWSp5iAgTUS19yYp14dGcZ8tlXNNGJfnqo9Kx224pu3NFFGYcVSRA5LXv+sO
         SykBa+tOvU6HTSFU6527Im+LU7FhlO6Fdo0w4oFFm97uwBZnAJuSj6+przmL00CUsGvA
         kYgx7UtlKXfapyJFP8Aif8FisTxdJ37vgNnldzv4/g+E/Q8nwuGeSSkYuoFwelPmmNGY
         NkSOv00OBXm7u0OB1X2cA9RjHv1KLVUhg/MNsoIPhg5sOkR1NEJFHSWpxWJaW4vCXdjf
         Nr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788814914; x=1789419714;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TGJyWqg8b9I8pDWEAS1fAo54dmwDkCp8//1b4QCLnMM=;
        b=A0QsIBSNOnIp7sQM/+rLQDMMDECNsNxJFrk8GJ8TDzZn6j6buWbc7/ugN1my+O7tn0
         Wy3lPtm/n9P6J+DRfFfOC1mMBlyFO4u4wmluY9b/pKFlliN43xBtUIW5N5pOIXqGNr3v
         RPtT6+qLQpHLT4BnG9sLfa4x7nBbvaYZ0rw2XDqhxkIywCl89tOurIlvB2hy+hex836Q
         FhoDkQesuwHbEO75ldxvTqwZj86qQU5eDXVa927l9BcK+6mGcTvX63EuYC73zTw4vwkB
         8p7vwy+gqPLUwN2+uIFDAwIcZLivGVZwTr/1okC0ssa8twGOTvWRaQzHTCa6msPH/iS2
         2CIQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCRrWv09w+WoOAhQUQ8Eu74mDXrRKqstVvaCYN/p/8v9VfMPYYtaytpJRvDmTdVpOXkw716UwPaw==@kvack.org
X-Gm-Message-State: AFuF++lvKHNEdTPPG+A/V4JxjzwxgYGTrYhP77AiP8x5bHQ3OBVaBgOz
	ZRiZiDQ8dJhk+LNWTNSsybXVE3SDaBxsIWFLJw4ea+p07le4oAQYg2mmTHjbZe0KKg==
X-Gm-Gg: AYBFou3nvSzsk+d774AZVg0EECxtHMj+8WlLcsxhXBeYxdwnOcvs26E2EJwRUYZI3AO
	k5Qt7SLpIFlShcBRTGWzaWWpC8+5s0NeFP2FrPJTHuRYgjDDrNG3Dh3bNGlLDxU5yhmeHj05l1h
	uQ3UhJ+/aIy8TZHXtVxRON+CyKJCsm7anVf5G2cF5UMIbGuMeizQ8KoVWUN5BkFaWamLYokDBHu
	ELWCSMaoLDRmF534qGc2VqWKOnSKQlX/K4a4IFT0aFc6RynnlsNYURCx1ZHPB3RecyMDqEL/bMS
	jo3TV5wHh1jNqMWKCZyuVlY7G6/R1AsHeRywyjUxf/53pDb554FfHyJtp68zeqOL76yiijsSUFo
	iOzXYvSMXRO1o2xoH6o/DRK8fTFrEA6lWXF5e6TKRKRj3K46Q1zok1iH9/wVqtND7CjsZn1aSCg
	P0Q+SgmH9hhRrQEwHrLaT6WaICSPxO33i/cHcHzPPJdgfwlRU4ptT4EaD5GbR4fBJeRGLlXP9wE
	333oJpYe8RQq1gu9TD2p/N5e0IxBPTYJNfmNfCb3qg95tKxAS5TbYJQWD6lCw4uZf6bhQ==
X-Received: by 2002:a17:902:e745:b0:2cf:4353:f117 with SMTP id d9443c01a7336-2db7773ef8bmr714085ad.0.1788814913291;
        Mon, 07 Sep 2026 14:01:53 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae92c5d72sm8942409a91.4.2026.09.07.14.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 14:01:52 -0700 (PDT)
Date: Mon, 7 Sep 2026 21:01:47 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>, tarunsahu@google.com, open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add documentation for
 dependencies
Message-ID: <ap3UCMlxUKU_DFDO@google.com>
References: <20260904220555.589752-1-skhawaja@google.com>
 <20260904220555.589752-2-skhawaja@google.com>
 <178872718104.3691424.15410189304450384708.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <178872718104.3691424.15410189304450384708.b4-review@b4>
X-Stat-Signature: 8wwii9w4m6sjhz6688dikokr6rdt9k6y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E81FC0009
X-Rspam-User: 
X-HE-Tag: 1788814915-638398
X-HE-Meta: U2FsdGVkX1/3qyuvTr1kZ1sC6mIetlJLTAlvTH6SPA0kzz/3KVq9qDVvk4awrwizgQZV7pylSMqJ8HNlyYZW7sVrDwSEBHlVykuE/GOWASdOgCBmWCxVscaDn3Rlqy4l190iqfop/XI5IWGTz1jhAGkWigfp5R98SbpgpgfN09b/lRgs8koqP5TKBtxAB/IdS1BI4vdqjWL1OgGE0qE8l4CFv6nyMF2xLW2ItFjMKZKzA3UNlJq6DzPKo20nzoRBKJAqnXMSazmJO8QmBmnSkpqkFegcITEJgOjOkwNyoSb4oCQDKe2Clpr0H5LQvee8mwm2aCyfGTcooFoApGC+A5UckLUtEL2iNWnPwLbNEwDGXPV4TeHmSmHeGe+mWXXYi0hEFluiUIcIHrAgpgHVSPElo8USB5D312x+Pq45P3VjSB7nYodZfA946k75bDWpu206uivYsXqdFfS1oHkH8QM+HExfNP/8eo7QeusEVsHcUjbNG2zLpg7SQO2wqTq/9oJQ2WXlyAzBHEYK5X+mLb/kY/2fv77NqJ7SrDyIM2KqDbeE/fzG8OKCSwYhn1kaZIY5JiHXM9Pt2Q0hpDddgsYTjj42aKswUKnmdTJxnDLcnTG9sj5wFVwJeoPtVlBgkbGmSQbDRHDdw1CQwEDEP0dUc8rIK8XIVPbjPXvippnqI89RjYlNgBHYs9V+K2jDKVg9kf15e4xml4dad+ra++hbOFUwzKmtKwJUdgo/LQ3TboS0FEHDYuTVV6bUVns2qR4JNMJnhHhTObAP9KXB4qWkCOIsmA18XezniHlcNQ7Q0KSGdB3nl/zcMG1uSv9vQS66j/KMTov+1tTIhS/WZg/y2muIeSCc8khbL1zYLfvhY48pJgK/Mfq0npyECZlj/y2pjt36IkRmUUjmvqFq+SPTLw7a5ZcGVj/qIgJqDgF/KMuIQAOjZdTOAbbA6y7tiXmXsiBRY7V4+2TTL5g
 ml0NEKXU
 xBRxf7VPpTeuzksvkKemeDOjY+1keC7VMT5Nwt7KoxbiiKmMPYFmKEAfK4lkYjtRD/EzdWWliltGsbkQelB7dOtV6JWRazvp6fMt7ZvBSLI9ozFBwrBtqFGgiWzTIGpD7JDebO1jTOaY6++GW++en6cCpoFNMBe8aDtNfB25iVNIeFIrDBXBhbJnQfNt+7RC0KUDWWbhWUwIFRkhEQJlyrWazDuzUjItwhoy6ehpL3b/qius2AlPX/BzETl8bBaUIH3aTJYJ9CfwjPSeLSHESNg8x3MQ4jCEZmpN7c3NtAxGAMszEFyby0A6qbFJl/JKstxMB40DtG66EqGKbFi99CcXH0To2rmDmV21TXFlZbNoY0F117tMFvbpUE9ZZTz0RI6LBZggpbzMRbWXAVNU2WC/nAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sun, Sep 06, 2026 at 11:39:41PM +0300, Mike Rapoport wrote:
>Hi Sami,
>
>> Add documentation for dependencies between FDs preserved by File
>> Handlers. This supplements the previously added
>
>Why capital F and H? :)
>
>I think we use "file handler" in the most places.

Ah, force of habit! You are right, it should be lowercased.

Let me send a v2 for this patch with the capitalization fixed. I will
check if I did the same in the source file also.

Thanks,
Sami
>
>-- 
>Sincerely yours,
>Mike.
>

