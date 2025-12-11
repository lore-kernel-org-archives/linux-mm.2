Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74392D41D7E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 18:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626B26B0027; Thu, 11 Dec 2025 13:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8636B0028; Thu, 11 Dec 2025 13:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE506B0029; Thu, 11 Dec 2025 13:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3880E6B0027
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:24:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8C9C8889D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 18:24:41 +0000 (UTC)
X-FDA: 84208015962.29.0188104
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id C7EE640006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 18:24:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YSOTF74J;
	spf=pass (imf11.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765477479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFrFvBFoSBllsimam77yErITX9FHt6tAqE6M9ZfsDfs=;
	b=poZnw5pllFJaA66go8mpJsIiFSCs8Ljk/PIfO78EWtT464r2zgRiJcI+OMZfXsoPcC/IJi
	4IqmvQOpzlts2F3flAtPlNLcRlB6MFMP13P7hRAUb0hv3fhxykmFGmTJNbXz8SqXk2jUn/
	TvJMHDT8ACHIRSJxYjpfhzh2+1uqokQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YSOTF74J;
	spf=pass (imf11.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765477479; a=rsa-sha256;
	cv=none;
	b=eBi+Q/7X+OVFcsZ4mkewbNANeYATVchMO2OBiYKuQJyMknFazt9eULtffRyycs5wDpLXv/
	apc41mVPHKsJraXZBpaRc8A4A9MozCH7qsgy4M3bwl1AbRn9QpRAGzhZOG9Dia13le7hFd
	PfdzbliFF2vi0CkaRoLd5Jd8/T6GSO8=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5959b2f3fc9so441173e87.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765477478; x=1766082278; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFrFvBFoSBllsimam77yErITX9FHt6tAqE6M9ZfsDfs=;
        b=YSOTF74Jd6tP4/3uBn/t0qdza8G5uyMYACvxCkWUWSI+h/7UM2KBQcSv+/IDGfxBP3
         G6l5D/yAcyfMWDLJsQyNQ+qYzECi+8/My0R0SDbfbakc3wxz2s8W31Xo8Pr2j7UsgzqE
         +TEq4gmv/pQ7dPK5BxT1GbzSAWuhB2976N/4ygBIofpsiGIfqdaJi3dY9Jf3GbSudM47
         if77dPc5ivQJkQNIJCaXIF0CClVKCuAJNQQX+3UXduioV+HARQC+AhtZ1SRUuUnucHiD
         PMaubes4PeHKOmB62OMhp7hPKDpwP8DLIWxE6FugxTVGVhypfdLTjLrvpHrvTBXKDGD+
         PuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765477478; x=1766082278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JFrFvBFoSBllsimam77yErITX9FHt6tAqE6M9ZfsDfs=;
        b=raBgMFJz7RCUPKxQs2BKOD7HQq/mINQKNrK5nlU6HGec+d2HrmerEvguUNHx0RkTjX
         G5ymb/V6ywrRbnrk/BYgNEGoFOF8fbQvLCmhdzOEurxm69eg0ejfvHM8MQX75/37IsD3
         +inyX0ed5fF45e/S7KgirSpnlDEnnOiamzTG6Jpg97YykV+LooF3jwgdwR8ZDE4n0Apo
         ffHDuCMXlPh4GhNs4z46phOUjUqtiIp6d4ZkxPuRQp1Ji1mAiQvyRjmjT573upW1r5R5
         72izpxevN4R1JoOdg1Ln1w1iTgRqLrvSt7RwT7JZCDYTZCEqvpySna5+Ba6cBFLrI1/E
         c2mw==
X-Forwarded-Encrypted: i=1; AJvYcCUDx6TkqYbM8ikqKRiPFJtqkhbme+fx7OtqNZxtULC026lc37y4LvFrRSxCjQIGKb86+Kzfwj8UQw==@kvack.org
X-Gm-Message-State: AOJu0YxozwulsMLQm5cx8R1wZIBqkJ3lZA7MBAzkSRHXxaXYBlFWa3R0
	nMHJTk4W7Mf5YCW6+3JJBPnvBeUz92gwEVqXMq6ke+6hxT0eF93HWN17
X-Gm-Gg: AY/fxX405MUBsfmMKlph9oRceD9nW4hUoFD1E9UkGWDOP/SoKdM8S1ntbpT5kADu5Z7
	sceDJDH0MMVbnvWxvcQ/bVCHe426AQ3VSWWqq2SEBLWA/eJa4uMk3Nv+mbQfFECAGXtfNu1WqkY
	ScnDcqTGKGVyPRfZpyUPZgw8DXXbN56XgXHPYd1WbOasKy0BpXjXWvXRRP82dy1bjVQOUAqXNAr
	RTq4CTSkYZDmeycPiFNmMUeWM9wK8lMjbP/69w6bCO/1GRyU1NNKUkx3npd+MLb9KoK74sYIOYe
	1rM9m6tNZSsTwCL/X4ceCLf1qxzPcP2YBKS7dMWhPFYMiqIW8vZUUdxpWFIEejXiqMWyIyBAddI
	6/M7znCjWxCCyzTAh89UeUs2bVmSAaDaPFP/cqawCCj9kaOJ1fN1BRS6im8Re+LkhvhZ1SlGGEB
	/QWvXoq6GObETisrpmhz4=
X-Google-Smtp-Source: AGHT+IFVxKB8gDiBMiJbinTn0xv4lsyliE65oXrRemLZRXTKoRg4ZE3AckW0VEdwuOTGsUa7HltYPg==
X-Received: by 2002:a05:6512:3089:b0:598:ef2a:448e with SMTP id 2adb3069b0e04-598ef2a4493mr2784604e87.10.1765477477520;
        Thu, 11 Dec 2025 10:24:37 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-598f3195189sm1060918e87.83.2025.12.11.10.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 10:24:36 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: adrelanos@whonix.org,
	arraybolt3@gmail.com,
	cryptsetup@lists.linux.dev,
	dm-devel@lists.linux.dev,
	gmazyland@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is exhausted
Date: Thu, 11 Dec 2025 21:24:29 +0300
Message-ID: <20251211182429.3300562-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7EE640006
X-Stat-Signature: ns7ss48a6x1hjhwnfqpzcyfrfbd88add
X-Rspam-User: 
X-HE-Tag: 1765477479-212716
X-HE-Meta: U2FsdGVkX1/p+yS+dyoggWiwIgzGIMEgmJaEoJhNKq8XsWCdjg1Fc5V0+f3bSRIPDjE3I32Gt+0Q9jjclZ1NxPHq92q+x6ZcQz5UOyVdIV0HdPhOX3cwBJ1k+tkR/9dKelt1dU2pqiU3NC9N6iAEUpej8KcQ8mR5+R4vnDfx2eD0EBcXI65O0tGon2V8fMYIdypsKvs4Dxs6itEc2ahpWz3uDuCGhB7x/SzgJ6pa16riGbVfTXfH+a1wpH7PLfaQWps4XMVrQYnbTRzDG1OBbTmpOLoferb2bHLAnmk8spsMFcH95PfF0aAyNxDsweFKqmhC20O8PKP1wCoK2J7mrtFTuz9+nyxK5ogtJCHj5ce5Mp+m2PKpMsza+vYGmzpO2iyzdLheyEHTeUS4Q4Nzo+4nYHJ6tHHUVNXNC29uMInQe6LzRZrND8qf5VGF+vmVmSRkcZLINwf3o8HEYuNn/ZOwpe9v2StZkpEASiDQeCzNdJHgFhUv/FmGKHhm2NDXDGVBuO7WpgMlu5MZK2DmOLEVqhbqvj6vxy/a1T63hI98YlTNRQz4nDl1vxZloCFD8a1jLfyALUYs0iXvgT61ppG5X1J+o6ahuvSPBmRqL2j7R/7a17Vr6cRHbl81NdRdHrx2LbFVhsp20xfyuj5dkKnInImLVUU2Khs7ov3jSkWJ5tqg99srSTYuXvJv1OWfAxUu+25SRvcmbhegdgW7qyF5pamaznLQs/M+MRcOuIHWtSDTWYphWB1VS7GwdU8zJ63qBTAajplr0eVxj9U4Oe3KXKIB8T8OBdEYmPujaQMZeCiQSaz553i/x/+iDnkJ7pvpA2xs8FPAu7MEGXHBlE7hNAJG1L/KGnuQF4Xxe+Ai9TbwRXE5I8KZhGcMK+ZOh2OANNQOJ50QdRh230khIJdDkdBqHg0qgYmxn9MnfRxf7y3UNLT997/wOMQ6McHQ9nhauHYAw2fqKr90kuH
 HIk2g9Vi
 n/ZSrK1Ptc0yzPDg6u+5T1FQFtEVBcOFo5MQ8cS8KOsXsdgpQObxUZeF6gRhWDvQxdLTxcy1zg9mwxaTKYOPjDfNE08j93/VoEF+BRS01o5Zm2W5MY2JorvKpN4ijtEhWD5axsmmt1zyb4/2nqJyhHBqIU0FH/HWKf7lvjjbzROPCG9xNLYRYRjLSk4rgXa2KbewlntYIflxByYojj2L8/3HQPabMfm8pP3FajXWmv/gp4ARr/cc9//ifroqYmvKd3mIFUeWSDndM/IJGpCIp49oF0I8e4jjvRm0MAGeAJbylgFX5BofahDqiiv9yYOJAjTYDXOvqhvMLfGCJnqskq5JXSMuSQ91zGSk449S8KAtavkotkZqhJcAPLLmSZxw4fD2oKZXrQYDw3ek8qpTHjh5yJtB+O3NkYaLjlmiDE5qYea10NZsQ12yy7jpG6KAGiqfEqTAtkJNbyG4Emwml1bM4gLql8uxDCKBUyWQZFy6OQ4FrXjodKcYzGHrOnTtOTWg8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000714, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> So, this is what happened to you - the machine runs out of memory, it 
> needs to swap out some pages, dm-crypt encrypts the pages and generates 
> write bios, the write bios are directed to the loop device, the loop 
> device directs them to the filesystem, the filesystem attempts to allocate 
> more memory => deadlock.

Does similar thing happen in my case? I. e. swap on top of dm-integrity on
top of partition? Is my use case supported? (I'm not talking about
hibernation now, just about swap.)

-- 
Askar Safin

