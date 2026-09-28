Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030D1CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C644D6B0088; Mon, 28 Sep 2026 11:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C153E6B008A; Mon, 28 Sep 2026 11:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B296B008C; Mon, 28 Sep 2026 11:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9253A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:04:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14397C0221
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:04:53 +0000 (UTC)
X-FDA: 85263493266.06.AD3865C
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id BC6ADA001C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:04:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=osLH0Hxc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790607890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjxG34ckArSJvICg7CN7SjHfhCj+djEKUlscplNZg6E=;
	b=lt45i5niLfs+A6i86wMtDkV2aBs4vKkSRccGrbYh8zSafvO3ULOh9M9+45L6VsaXX5Wsni
	3dqBXkJ4RDyKnaeqAlIaqLKYnqPBdsWeUM1VG1CZ4d9lVxo1YxY1lgQdGVplfKVkwhWhdz
	1Yhu8Ai+W+k8Axlo+oPoAEM3o8+vF4c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=osLH0Hxc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790607890;
	b=cw5dqGM62HZkcuAkggAfj5F5Aoy9u92Ca3QR7fZ05MLq4C//zD/38Gl0cgpFAKzY/h6IAs
	MygnlWw9xNVGQk5NiBwsE7k7GJZjHb3/m5p/fR2vQ4NzJtBJyh7Ul9l3Mj/egR3I2WdKAI
	wUiwLpWSQiea737oRAiFmZ7NshgLJcM=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6ac64e54f2fso1874185a12.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790607889; x=1791212689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WjxG34ckArSJvICg7CN7SjHfhCj+djEKUlscplNZg6E=;
        b=osLH0Hxc1O7EHoT0U92dhPfpFChzLWB73heDIPLGQZqbTAX4aDbju36DYJbdVZWTMn
         CW5a748vjfFdbGahijab/piPzrTOSzlOUegtLwMlTg9T8k1gjkOYZXU3LUl9YTAsCLPI
         UZN4V8en4Gc0K0G8MP6eikn/YvOPZC53GKorvKNLniHzJoU8DzPwbWI3cnVQZnwXEJDJ
         L7XTWwiTzkOa/iTiwEKrazuEEdVTKYcbYPRE8F5v/OqVWk4LYWPqHUarPF8ZeyYwzSAh
         kq/BtKL3laGrS6v7jB5QRiS0x6tYLFYZIoTwTj/IktlGI47dmYaAHe4fOaZcCoTXjmBn
         QpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790607889; x=1791212689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WjxG34ckArSJvICg7CN7SjHfhCj+djEKUlscplNZg6E=;
        b=dOQQN07LnZb1oFn5hBz5giVoG3puFIqpjqcAYj4zxmgXF4RuungHVlN2KFeehfdlUn
         /2ilYMkIRYRS9UCjR03rqEgcKv90r4vkBMwx4/nKZr2X+82pqhBRf5rFZIyqZndk/77W
         pbvMA+bDU0VTV2VC+P17BIvQXr7j+cRYdHsQB7KuoecEZOTCvwDm25kioGVrIprebUK9
         styxhUTLtYYTpzgLtGek5jqRLF1MogcrOsdIFYB+FXfeOlocYZzZGT3et2dC3nziYftJ
         X2af5Wr7K5FlZJuzdZqTYR7RCfNCTtS1AefgVqN8dBQde9eVLWUH1Fb8SvkFwVeK3z02
         6REg==
X-Forwarded-Encrypted: i=1; AKwUvBzLkYr5YmpUc+vCmqIE4TJ5k/v0zqDAjfVSp9crrUeiCM5z6RI5E3Qvrl+cEWd+hytUSwV2BM0rgA==@kvack.org
X-Gm-Message-State: AFuF++mn5x8H4KFOXwZYcs6o5MoGQApELf3igkNRLGm5MJkcD3r76qOS
	ErXxP6jNQQ0Dl+dKQztax7fHT8Rkm73+z1dwXtxf1aC7xmrbaazzO22W
X-Gm-Gg: AYBFou2jRYUfXSyPqnh5hxAKZXwmykawT8OCIu6DIKLheu9sdXOZytIKQ+lDufmga/A
	f56/bKPPExZwwjOlQ0DHlcq5bM62WFuf4W1IO0LkuzHzCUkHU0Qt9wmWNo8dAEf4W4RDYBl1UEY
	55QPD+N0XGGen61J8zg6AYyltUjigQr4PfEHwNwHs8nePrJtXoUFQR5Z6IMTVmXclLEKGcM5Zi0
	3XQSgBOiVq5LFrsCLsb2AjG1V19BVthQsxxB0Au0sAyzYBxwPKjqh/ZUXqFoCbGPnUgkF+Jd4oJ
	V1D5ZY66O7LiE7B0fFRLn19TuTW1JSW3EiRmwIhgzCDeFcX76N4XssPDXwVTXTszNtI4zaleDSg
	raKwMXgu5F7V8SebeaB0NNpE+RkzhGr5i8PpHDrtS5dosQQDhi5e69fFT4nBNFU0oGZREVzyahv
	4nAPGLnRQWwAnpS0Mz3ryzYqxFbJS7kQAF8a0qpZp36AqXrrsZWBjGGOHZwxV2kVF61vfepZ2Tb
	eNqWWAqDjSyrD9qDVYn98vWpdrq
X-Received: by 2002:a17:907:9689:b0:c26:1cfd:4244 with SMTP id a640c23a62f3a-c2ac225671amr1087174866b.11.1790607888866;
        Mon, 28 Sep 2026 08:04:48 -0700 (PDT)
Received: from APAPAG-M-7WYW ([185.10.235.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae757b9c1sm495522866b.33.2026.09.28.08.04.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 08:04:47 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	bpf@vger.kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tasos.papagiannnis@gmail.com
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Date: Mon, 28 Sep 2026 17:04:46 +0200
Message-ID: <20260928150446.36873-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <arZzn0bwWqp7xTE5@gremlin>
References: <arZzn0bwWqp7xTE5@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x5pou65eo3mtcwdaiydu34c37wbrz4cx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC6ADA001C
X-HE-Tag: 1790607890-482372
X-HE-Meta: U2FsdGVkX19bhcGCq0aX3y1yCO4KVeJeaA8KmkB+cyZEm1DOm5pdcI43bXSb9thGjykHmRSbR9b3LJQ8qhbQ/7pajRsJhLCQYAjF32NSn+VLw+YkFdNW613VSvJMFJbZsaBj4zpciL5aUuhG/ou3ldcliO/0u2hGgiMqr7F1TFjCW7FMz6ksfDDHZSpA3sad0/bb1C4CpfO8Ic7UAhNZlorMfPPZj4ibaADPqLxQ8ztW1okBoD5VIb0fVzrVzkE4+BvWBCyu+LMXT7s7K1b/slPnFpzuz7FlhnanBDzCH+ERKV/c5lisEcQei+nINNTNBxqBK6RvYxd2ylvA4EMVgpxPnz9zzeM0tVbIU0ejKWR37Aujtc9UJrQaf/iuNq8c9qn/P1/fwww61Z5B1b92aeHBehOw3w6K+1/noawIqFgRnhYskWX7mD39/auG2zYP86IapghmEQgiGoSyavPJ+toF6+92USd55xn8Hj2BfobK0PbXlTYzE3ezV+AeXTGuRcH7j1GgX+geWOXt7XcpaXY1VNvUA0x0noNe2B1+Rdh/nrQgAMFUDkK4YpM9zBz6uV1DasfDBEKsVW8/NeYWW0nMea3hlgXjPnRqEK1dQXS+DPCcNlz6JbaiL8iaESQhxEJtNpyYlYURxMjwELrQny31pkjneYHN1bFhD6OKliFkBFvhORVW8qcGI8C2lTcYX7gRU2diOlztFckLXfI43uCydQ28Z0cll6l0AqvFAZMILPtJWmTxLydGGDgiFH766RTMD/bDOMGK+cbMl9HQab7saM2pt5lHkDsI7Xvrl922jiVsVmJyFz4N0EPD5zgWD2E5wSR21vEjR/eF09TPH5zR238lGsG4opnlIH6FyPj+7khPNv8f9xXgHTluwW0M/YWHSR9kDL+1syZBQ/qpOMIlCC9+1TJTohd9UoKNFbLnnM126EGRhrXqWGr24TsCYlPuj9LmazW7ht3ZALD
 N4E3wkJD
 t5qmLmfiNGrsPvq5u8Yxlf8jOXXNyhFz1O6TACBHhgSmv3oRi+nf6vEMvDpD6AUcPTyv1D35g7a+0iZzUFMPKPu7TPF+CNkrkLDrsp9EoZKaDtUzdtBVmDnBa7sS4XcUc2hYyuj2FzFIwp1unr8aEjAHATz2eFZIm0w5Phctr+QUnFNTuz70L46VWbfBRqf32zndj3nJgOM+WAG3F+qtbh/D6Dr2Ur3tSQIfpLwjCsPFFRgZeK9tm4BwKzAlCoTQUVfu6y6Ha8SNACBFLDOAuK4kKvWDu3s8SAg1yC82ZFL6FJXW58SnorGER32HWYR3FfXQ9G9dd47g9Y6kKlbzQbegMpqMiivBOjFewAv6/dzvnv8zOC98M4WcKRWqI+gdmfKvnIBo6brrc8s56pIiMmw/a43kK9Eo9h8U5APsjSvKbxRv49/qdNAgSPlnvx4rvBVxltqZcxq6Mamu9tXFXnpSqwDtFp9nkBRchKUEYvlEHlgQVGufhg1s2P8m0SlxgHMibtghMDsuHnwyJfCZUcuDTvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> BTW always feel free to nag if you're not getting review! Something things
> get missed. (Though I'd say wait at least a couple weeks before doing
> that!)

Thanks! To be honest, it wasn't clear to me that I should take any futher action
after I received an email that this patch was added to mm-new. But after reading
that email again, this seems to be the case. The patch is still open for reviews.
(Sorry, still learning how the process works..)

[...]

> Seems reasonable to me! So:

> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Should I now send a v2 with those changes? It seems that these are already applied
in https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=1b721712d07e831686de53efc667561985897956.

Thanks,
Anastasios

