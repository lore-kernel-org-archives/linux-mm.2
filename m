Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E5ECA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89ADF8E0003; Wed,  3 Sep 2025 05:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872258E0001; Wed,  3 Sep 2025 05:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEA08E0003; Wed,  3 Sep 2025 05:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD828E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:54:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13C7759BEC
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:54:27 +0000 (UTC)
X-FDA: 83847478974.17.FA7A24F
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31C8914000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:54:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xgb8cGru;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756893265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2Rzk7zMFMEV7RW/mx0yGAjSShG/CZFQjSUWSelah8c=;
	b=WlIySc84ARM7UFMkjpli5vO5d74nzl/ADy9NrD1s2iDgX3JzBIFX9i/FyJ7u3ZwVrTsAny
	S9uKuu4hKHgJIZI5ypJIJSDrcO/cgsvGANd54hcmCn1GuYtro5ker/h5IJNVU2gl26I6hq
	tQyFRfJ3Xn7RO2pR+V4NE3Jjs9BHkUY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xgb8cGru;
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756893265; a=rsa-sha256;
	cv=none;
	b=mQBKFdwHk6i31e2RfGk7HXF0CwpcE0mi/6DnqHMnuk8dpU5jwfc6j4RHwfvxQ9DVi4Z7dL
	ARnymACiY2U72KlgVk8p6Wsh4vvywHzQ+srOiQE6muzZn73Q2BuffdPwvlPfy0xPogsCug
	+9AyTFka6c+vOYQuR8ZJvS5aqDucU5g=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7211b09f649so14120526d6.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756893264; x=1757498064; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n2Rzk7zMFMEV7RW/mx0yGAjSShG/CZFQjSUWSelah8c=;
        b=xgb8cGruobn50Rc/X1R5rW3DNY25jLB4myGFTYafrfeVggWO/nmYDdUeL60eiEeD5O
         Si9BoEPQKxQ+7C7BzhnIpUYCA74CvmSfFKSXoH0dNbX+64rGXPHyE2k/2D+UNWNkUfK5
         K2yCoWZ3lgE5XSF7MnnQV1As7xV0fTL7zwjPbEDUSMWjGgTALtwQCsZw9tAvlxvpmLWm
         qBncpNPHvdR+x8GWP29meRhkLBSJeShW8vyhaFuNmvw9EWsgrvc3CmgWLmIRQ9ah+TVd
         v2UJiZcTaAHAMZO5YUO1I5oRLjyDMPVXgEzq/leVX1i/B0P5QwYVXn+SvODtTXcN8Tjl
         2TWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756893264; x=1757498064;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2Rzk7zMFMEV7RW/mx0yGAjSShG/CZFQjSUWSelah8c=;
        b=MwZmNIZmFDM58joWtg3emTgC+moejwXCFTAhJaMhZf/e834YM47GoaNc756Ey7ZfJS
         MasYIjhm1sF09O3ly28v4LkVODX/xeRwUNyNE9LCVuSzgUD//vWQ8g7Na/YexE8lZcL1
         +OIDTXB8KUOd8tifLvf+O+/z/WIpb8iSlNSO1YzsO99pcf1T/SgTYkTM+/omdxerMflo
         QWp/cnC8SQO3ktCrwdgdKoQEcM2jF5TbEvW3b+b+3nM47W5UfNL3xLtqcb4rs8K843JM
         pMqkDkfCu+FZOzERkgZNwuA3MdG9c8C7bqenswQ2OtrWcOXKiFi7RFcM5c8wHrWThIR8
         AEew==
X-Forwarded-Encrypted: i=1; AJvYcCUM8zPswBT3EWHdSTGHEXNhUjse34xMx2DorKwnVHY/TLQiohP9pDTlyl0MhURhdd6dy6vcQUWs3g==@kvack.org
X-Gm-Message-State: AOJu0YzfaQywxTDPompaGAi/e0Z1+njQAzgM6EHb6Gmd3NKQh+tBgWEQ
	7cadLp8DLmROAEUgX/VVkuPcAHIswdCPB1wXSZdhH1jfxExfVinpg8MO39yEmDWATWJX9Z+/gui
	C5tmsAaKjes3M2ODRjC0QS9Vpjm9NGz0eFr2c/P/6
X-Gm-Gg: ASbGncsVT3a9wlBAzFP+dJWk6LdebSks9S0Ulu8H7iAhhCLcXXU9BDSucwgdNNGfCSt
	jz9rJoPbQIDDerdVQZuWV6v0/71z61kwWwZiuTCrLw/3K1NHz8Ry0rabCry/oG7DzJHJK8MpKYf
	G+Zy6sZAaJR96ZDgBXZAQtdpyPwQuPw/DP5Xq7u1+BUjoYLg7/YGH0tf4WrKdxlVsxu+v3C2Bdj
	wjtWMD/DUeo0S4nGlkLRh3teH2kH2ML17nCXqkNlWc=
X-Google-Smtp-Source: AGHT+IHHxZ7Hfb0qrsN8QMhYVtNZyxle5uZ0dlr8VDvhNcjFGlkqe7J8XNVXFgqPaB9c4DZ7Jz/xYjkzW/9XPfW8urE=
X-Received: by 2002:ad4:5dc9:0:b0:70d:fee8:e588 with SMTP id
 6a1803df08f44-70fac870233mr189626166d6.34.1756893264049; Wed, 03 Sep 2025
 02:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-4-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-4-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 11:53:46 +0200
X-Gm-Features: Ac12FXz83uIidiq7UvM7XG7YD3kWK8XfBqOv9db-g6kDKvYfHmTPpgNK10-2Ga0
Message-ID: <CAG_fn=UX9+1=CwGB-KCe+s85ZzQXfhqO+2dJVqs93XLKYedeWw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 3/7] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 31C8914000C
X-Rspam-User: 
X-Stat-Signature: 4y641bh1quu6cj67hz93ueeaqbgcn9kz
X-Rspamd-Server: rspam09
X-HE-Tag: 1756893265-604069
X-HE-Meta: U2FsdGVkX188c90Z78aJB2WbWz4h4g4EbozOBTAbSMwBV+Lhvfw2DKnOAyPU8in18jhm+7nAMlI8wiPv9MLJbGLjNEKpxcJBQXf5Xf0JJhfTQ38j7tFNZGA3xVw1woyk+03npKKh2d9YkAIgmM9MUsSvnuXMx6Vmfw5XXRjAfUV/SWPYSMWw+/p8J1yKkuuWGi9CScdWYoZgibAdyiVFjNvOfH6Pu6DJ6uhk9V/7chRukztFxHK2ssxjTIPvuqsE7pW5Bj/V6DvVxOJXCAM2JxKY+j8qswQf6yGXvcyJEPz72cNc/D5YA2ZzMvdoA7aQv8xMpTZnho8lhRAdoU5fig273UJwpQOQV6q3oX1uNa2sdeOWTqGrqRekXO2hyEe80VfyK+e0KC2tnHHVOnCFHwmBnu0fvyzvrAM61Z1sOGc9aWCFs9imhoWIOX/B++RJq0SY7JuVr8sVsAdrLKCpgBtQTlhtrymRjLzDUzNEOQW/gNGqzUTT1LkzLIRug99L1KpMiOHu/tuMjO7+jFCfKO1ZZ1Z9ZXBleKBzKp0BuXQpDeu+ecuThz7xCgAuKpKjObZQle7pGCjByVOAHf0ZOC6HpidysxCjOYPhQFP5HcfHD0bexYp4wfm5uh+lATLHI97ImP/zmw2HkrFHDmwd4o/TrlPoVS+L3nK1681ZuEnaNbxSvQFxgbgP7CQNGmYKLzVcyiXUOM+dVtQscAI8PIP7eqlmoOx7TuECW9uA7qXU+zYCXuCtAuRdGmEFrfzOakrqJa/AibuZ82UWTcrzTUw3XgGieFgAmN0R6Cia5FiuA6v3bNWCz8HwzP35lqBEtwDBjBm0QoK13I2E8B1VjedC/lwIq6hIYfUnVQWuhtPGX14iNfINe1XCBaR/Z/x2jxTMMKugLWh3I2Q5GF7hMjKfPVqfMxXgY7EIkakPz16rs0tXmWsBOHVKMYTUpUO6tkimuwlhpFRDeLo5v/t
 3g8gvPZW
 x3icH+4UrCEXCPNEe5KuwLd3T6i3Aq8/HRHSu+LWIPnYOI7YHKhHsgXN6YwZJJ7O8ZvcLIlJidha2EsqCqPbHt9u7gt0JxLX2fPpbdlNwZQHaBMIOckpTPRy/k6AFvSUbKaVH8Mxbmq5m5TaXoTGzkYr7P2/SKPGc5jp+ieuZ4Z9ylRjMzlIA6zHTAdY0PqukMPmy1U7QPJUM+VRLhmUu5+/dTFMvA/DDKVH10pbqKTuzelmUgg724VwYHaEFq/oWyt73jx/G+OxugvK2Vev8dZ2rAZsTQ7A3YZdWMGPGf76zRoifeZ1KSs4y9TETKwtAwcu1bKW2k8qJfx2q4mhIYgJuBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/**
> + * struct kfuzztest_simple_fuzzer_state - Global state for the KFTF module.

s/KFTF/KFuzzTest


> +
> +               pr_info("KFuzzTest: registered target %s", targ->name);
> +       }
> +
> +       /* Taint the kernel after successfully creating the debugfs entries. */
> +       add_taint(TAINT_TEST, LOCKDEP_STILL_OK);

Maybe elaborate a little that we taint the kernel because these entry
points allow calling (almost) arbitrary kernel code upon user request?


> +       /* Patch pointers. */
> +       for (i = 0; i < rt->num_entries; i++) {
> +               re = rt->entries[i];
> +               src = regions->regions[re.region_id];
> +               ptr_location = (uintptr_t *)((char *)payload_start + src.offset + re.region_offset);
> +               if (re.value == KFUZZTEST_REGIONID_NULL)
> +                       *ptr_location = (uintptr_t)NULL;
> +               else if (re.value < regions->num_regions) {
> +                       dst = regions->regions[re.value];
> +                       *ptr_location = (uintptr_t)((char *)payload_start + dst.offset);
> +               } else
> +                       return -EINVAL;

There should be braces around this return statement, see
https://www.kernel.org/doc/html/latest/process/coding-style.html#placing-braces-and-spaces.

> +
> +static bool kfuzztest_input_is_valid(struct reloc_region_array *regions, struct reloc_table *rt, void *payload_start,
> +                                    void *payload_end)
> +{
> +       size_t payload_size = (char *)payload_end - (char *)payload_start;

You seem to be casting payload_start and payload_end to char* almost
everywhere, maybe declare them as [unsigned] char * instead?

