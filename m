Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE410606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vX743oeP
Received: by kanga.kvack.org (Postfix)
	id D2D346B05B2; Thu, 26 Nov 2026 00:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDE56B05B3; Thu, 26 Nov 2026 00:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDD86B05B4; Thu, 26 Nov 2026 00:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91EF46B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:36:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B6D6402CE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:36:30 +0000 (UTC)
X-FDA: 85476160140.22.16812B2
Received: from mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id B483D40007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:36:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vX743oeP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795671388;
	b=GKSr3qrAyzwaYgvB4MybUMyCPa6YcngcfpVi/IApU7NmBpsLXeiKoAvrFj+1a4j+Ij7/lM
	hG9B5oyBs4WRoMWlL3dI1PLUQ14lfJD9mSa78eejxe+dMnm43oclqxnxKX+SQhpe7UL+gp
	jf6N4fMxW7KytWRgOGgz7gx1V8PdxFw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795671388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AodBlwpDiWRSi288fIhZCa0nGcYDVws6bZrTK/h3RpA=;
	b=6zkgiQHFgeAKnh4gYaxmNe1aPhi/MFSgt2YpR628USiNHr40nphKUsw1JYPWqcNiZcN/NG
	6WzMaBR+8kTLTsSBF7iu5erSko1o/7uZuF5H39mfSMZhwVfYDQ1aIiMcmus493KFaJi0NP
	RBM4bGz9PmN19BPYr/jET3XkdZtylK8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vX743oeP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kp2zkzyDc865q46+d1AEFq6uaEh8U+dzJCBvqx8kpkY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795671385; v=1; x=1796276185;
 b=vX743oePNPEydQplnwINqOUy5lJqMh01VM2ZPDFF2SVsUMxnocCj7Cf9I1dW7qS5HdacfeaM
 Gw9JqE+mroOrbHa+lFQPeOukysVsirZVAoezam1R+ZJO/6aswokPexi7yPNqwbHTJWrQCZk1cVn
 K3r0O40RdJIXlc3zhsskHt/I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 69ea2c5db0ff0af8;
	Thu, 26 Nov 2026 05:36:25 +0000
X-Mizu-Trace-ID: 69ea2c5db0ff0af8
X-Migadu-Flow: FLOW_OUT
Message-ID: <18dd1ee6-21a6-40ab-968b-33042a2e11d8@linux.dev>
Date: Thu, 26 Nov 2026 13:36:21 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/27] mm/damon/core: introduce damon_submit_report()
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-4-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-4-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B483D40007
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qr9xw8axyicbw3ti1nm9tqa6zwh99f9c
X-HE-Tag: 1795671387-745965
X-HE-Meta: U2FsdGVkX18LCrT5Z8GT1R5jmLq3PTT5w9MEAdqQtsSyqt1ULMk1L/3yNkMA5QM19tS9VI4e+JyJSKIOQAgaODzIkIbEEpdmukMwYiwqqy7nr07dcAfsH+i9zLGhcIO++LlYO2Dv8gVlsj8b+9Swg4P1XhiGP3kLTe3aVJX2Y5CmZ59ILkI6jfPVWTQosxOAmnM9hOHkt0NcQwJop27ps0MViv5R7fG9zILbvfMVQchMPiyObqtly1qJDbEmoke5pUBrKzG4vCpAP7ZrdA91/Sq6zH3utMiY4U3/A49UHn27lrRObOue09rYQq7olzE4jwP++qEf9bjliokrndxEabA280BOzwH4J8sVEV15wsnF5rY+hIml8V0VXAONwMoQ3gPtp/bFFCIbh3jBDyonWE8KZ/LGZLAWT3EfYrsX4Br7Urgbnxuw4V1hKHEIzSEtAYgVMI2HzJ5Vg/M3unpbL/kPMBJQ85vVVtigiD++mHFdJ7Na3LQfFpLCDkUHbotFdngTOhwgKfYhAKy6B+U+nfb/JCrqC6zkfrw/MM8T0M4Yjpk4eQGznO6yFpjBRedY5/WANT1aDvAy6I/OoEnGi/P0+ZcbBwFCsIJk1JLvGmXVW6cwP3mvguimZKDgFCM0AqixAYKVVgHYnZq6g8fcmTQBXWasswHvqzTBzwkzWHOKwb8AGEzHxZSocoT5JnsC5vGfUm7xGLVXH6JFkutaVHmuf/D0/deGShdWZq5CuRbYLbFkPs070KDG4u/e0L6T5Q+wxdEkC1sngsNWL1swKHgWT1Fu9O+PFV6RS8uSIDelgQXdGK7KjAkWbZK0LaDmLYv+pDXpB1Ij0zdfM9/SgV3Ly2Fq1nOIwdDJWK42GwGekIL9SUNAwBRqdCiTp+OlboBbz8zeKJZu+gSzS30tX21jDeWUUW2WEQVcjd0DQEsOv082kyvPlmrIKKz5zjPWV6sJOgzEU/H4bzzfzwn
 BgUx4vYt
 ZzIeIJtV5e1oAJtjCSvmKGzpcoXsTE16uruvCQqehwPZ7i0p54JN4WF7lJ4Kmt0k1zHsYoMtPTMW7uQyJh8afBLg9VXZ5vmFh5ONUlCLAk7JdWqa7NvoUhUF0qCoXJ44J6E8ZSXRaLn7zG4rnnFqcfc/9nWhHQwkSdDXNXBBN45Npfh7hCDTQzN4aigyskOodROwqEbON3xu2+NtgqjGnh3Cvx9V4V9ZPon7ah6dodvz5R5SXVYyhhfRD4HJc1K818pPu314JP+2Ywi/A7U8leF1dw0Cs1c7ScvByJS5eYRzUnQN98R8GIlCjRcvQx3AWFseiYgRGTsHfr83K96BHeX2YQPd0SwOTKJEWQrOCN/MCxpHPUENllqtnP4gJ2b0XaaVW60dGjtRJq5LLJAxfphLSRDtkk35gS8gPXeKcBWQtHzObfLFWbfSQFPZm9uFG1sjs7GDvlynDrzBzwb2JXWYtiMrgUQE34kYAm2Z1rNmMeH2DG77gUnxDWN5lcFV2yzUlhiw4IU+gJovMPc0vAYdoX/UPp5zPzvrL7hpliQTgW0xeMore5Fot/D4nxy+3gDwZ/UX5PHkD1Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Implement and expose a new DAMON API function for submitting a data
> attribute report.  Any kernel component in any context including NMI
> context can use it to report their finding of data attribute information
> for a given memory.
> 
> The function copies the content of the report into the DAMON-internal
> report queue.  The copy is done in a ring buffer-like manner, without
> being blocked for consumption.  As a result, the queue keeps the latest
> reports up to its capacity.
> 
> Use simple CAS-based try-locking.  If any parallel submission is
> detected, simply forgive the submission.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

