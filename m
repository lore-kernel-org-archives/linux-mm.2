Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB92606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tBFKuf02
Received: by kanga.kvack.org (Postfix)
	id E04646B05B5; Mon, 26 Oct 2026 20:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3FB6B05B6; Mon, 26 Oct 2026 20:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2E76B05B7; Mon, 26 Oct 2026 20:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0B26B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:58:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F333A0933
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:58:00 +0000 (UTC)
X-FDA: 85366594320.30.63F5B44
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4945D40008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:57:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBFKuf02;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793062678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PixEuIlz0J326DRKLzRZTRCRckMWEmO8LrFWZwm2Ojs=;
	b=oc0bv9rltBsGXZM6gvHU7A9NZ23JulWvKljVJYVLWDGouw2RC2xTjUAkJCZwA56FxEYHZe
	pWQLJfe5WsGJyXpRJDdIB4uJO4zXRuY04Z3JOFj+PCYO1zbPWMW856HHu75d2kwT2JFWp0
	jsFFP6gJ+CT7OXtNWJB1ZghczIlHpOE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBFKuf02;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793062678;
	b=DYu+rMgTbJ2r4Y75bX+Xq2msb2LSrUEwP5VsuZNsqSUWvhlAJoFFKEEz/FE2SHQ5wnA8cK
	w1f0orFicoLB4eYPlOja4ZAOfc4ZIujXlMyyESmylju/JSbbok5SyM9c8nYIzy+kDpC9Yj
	3MYn3JmdUA+SVweGlY4lvftIWdIxCFA=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso5482749a12.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793062677; x=1793667477; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PixEuIlz0J326DRKLzRZTRCRckMWEmO8LrFWZwm2Ojs=;
        b=tBFKuf02T3S4EOzrUmSOz1XqwJ6TmroaFM+w/vBxIZDtir4wFLn0Dzuxm9hbZbe4TY
         o0HgXysG89AMepEZ1KFJze5yv2UmpuOAxFSmGC5S/5m0e67+J+AqeYzkKvvZ1YuPP/Sp
         cuy6rC88JmzPbHL8s2Xplo29mLpeMn3DZOyBgtWMrRE2SWf1nsa45rausxcL/BTLU5cj
         MRSeYHV4Xf0/eMF5VLB/b2ljr1dhj13MVIOwimSYVkxJPDiRimR72eKijrttK90BBHsw
         45F6JGXZm5AN9DG0cPgIdPPsNCYOXQZkKLcvoJrY9NWU9pZI2TT6YAnn9r5T0DCjM3t9
         FyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793062677; x=1793667477;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PixEuIlz0J326DRKLzRZTRCRckMWEmO8LrFWZwm2Ojs=;
        b=KAkE/4DgoCe2BBu88M0XttKujL69DKZkW6Re72pTlI/PUiMZcW7ZgiHp8W3kN/mqwc
         lv1fcUo0mLqwNNlukmJuU/NsRA3b/afhPkqmLUVc2KpDgxUHnvG2avTYDiX9U0di4PBg
         S9yPwO48KuxJGH1qXVOGd8+7DJuJiV/VORl7WDgykhVFBTt2LeuezqsYpwKfKwAHednz
         4/p58i/bn4nFcjaEz+8Cz3CuOwcCEqpjldzD2w0OL7n3Gg3/cAzpJiZTPKW0XS/aaANd
         2AU8ilgQr4RiE7bwb9YsztWmFFlr8kDRa+XuiLBAld5lJM7telsb2cjkI/mg3D88S1kg
         6cgw==
X-Forwarded-Encrypted: i=1; AKwUvByaGZJ489lQYDQvm2Fx/4LLpgltP/iAugTXosK3vo9fgaR429hhhE0up0FEIILA6H59W07bsxvncw==@kvack.org
X-Gm-Message-State: AFq9FYItZ9CyxwcNmd7L6U4s6niLgpmLK0dVPKB0NDpJ2LwwB8bN/iJT
	ivCvsY0WYP/CJKfYO9gm7QEp+RV0Hne1e1f3rXrY3FwFOx+ejvXwyCdt
X-Gm-Gg: AYBFou1VQJSBcmC4UzOSldmmEoUUYN/myeey5inhO/1buIY7nY8UU+LMSJMNJBa2U3r
	9ACUT3R4xx33+3VejD0MySmI7OxXNT6Go7rKVmC5rnB4GgFHb5IjlL+aD+NTexKD0DxL0/10Xhw
	W2Lg2twltiHaPiOTWxJcRdS+3FqAayid9cKLK7g6Q7PdAr8a4nXtBJEk8JTSg7qzs58Lu622QW2
	VTKHZ1uhvEAaX8XZA5WIaTo3UHCvNnWVmqbociwVObMA7L535MZnV2l0CKUvn2R+CYTfVKsh4Pc
	8ONJptRqyf/8zyaX0nvgnxLqsD4n2yq9pADdXZjCTiu/ATLUcS9eJI/DZMSho7WQYjTDO+li0/8
	ZsNv4U2eqJOTQzZ3U8U5F7iNxNchTj1tUGrsC48XeWjx0+KFfp5WhVxOHY9TSPdVZs+gdOYAPV1
	77axwzFpdBVJHLcqBoT/HbFqeq2ynv8FjZ8IP/TlZf1nbKRPa9cpujeO042GksEeVwCTcu/GAnj
	1qx4LmKVKb/w4EPkhiNwfE1Nr+XdRijrYqamCu9N7s8fecGWK9zt78tNQRfqLtZ0VZHzzfyktsY
	ZHOIYJcn9oAGST7cDn/vRihLFKMFVegaDgNKiaN+k/eQ6iRohlLjmX8dOY8aTVPH9YbcKkl/64Y
	xS8RHp4ClS5049dI9ktMbzndY88rbM0lyOJNavNJIqahMo1rJhZBGf8Agbfbk7teGYSTuTelEoE
	7DdNFM1OBGNNIt1BU=
X-Received: by 2002:a17:906:f593:b0:c31:8984:7fad with SMTP id a640c23a62f3a-c46bddf6451mr917653766b.15.1793062676398;
        Mon, 26 Oct 2026 17:57:56 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b44595df8fsm4283637a12.11.2026.10.26.17.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 17:57:56 -0700 (PDT)
Message-ID: <083c2bb0-85b6-480e-afcb-bd2f386f2ddd@gmail.com>
Date: Tue, 27 Oct 2026 01:57:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
To: Ian Kent <raven@themaw.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 driver-core@lists.linux.dev, autofs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
 <cover.1792577179.git.krystianmkaniewski@gmail.com>
 <dc65c28e408d6b64d4b13b7ad30e5fe70ddaa441.camel@themaw.net>
 <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4945D40008
X-Stat-Signature: gcbh9mhbasu8kxk81n6aaoo7zpz1pf3w
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793062678-175065
X-HE-Meta: U2FsdGVkX1+EqBU4BFZs00JU1H3K1VZbu6fmRCR8UYQZ8noaai5A7nygnaHHqmErLWcPnSCqoZ44uqTy7QL/O2NmCpzVqXmeQGz35TacipkbDijBUFTylmyCHL9H8TocgUzAqfxtxlEKirjNECTscFRYbZS+qAeAcQWzCh/SfvW0Di4uS+tCt/ofMh/UWWjF3n2YTOnByJimhDSle4JcQgXyvD2RUzxF7HMqhRZA4BtWHXYdQETAaFju3rWCC+KdNlxvGkpqQYIgeqYnXEiSPOKYkXL8k/aJQ0slNmUSHrm9Pt/UPuruY/QGP9/Dg2okyK7a6orOPHKVSvcjubmy2sEcej+cVV9eaJc2gjZ4GVT5yhvLAVPXdRZnRbhq70eIRHvI4J9xNpXg6G6ejKvVxM+31wXMgaPk9Da6soDAfZ2Mqqsr4KAy7ncFeIjuAD/BZEHCvHIHQyPLtQ0sb2gz+v3kFQTgxte5Bw8SmNqDPymLK7KrPawSHW8IUrHzEds485CnzOrLmN5EOGt3YXfHQ0pO64WT4pUD3hnPczmCYvA73dd8CiNKOSqzJJTEjo4kG+HQRZtHSJk0/Tgu1z5Rv0ubm0bsVR4R3odD/0hI7WWkKA+oweM89R/0ZQciUt809muuKZxjieykYV7WZu6SNR/v6Zl3MvEo9dFKrybH1ILoWflfc721DKQ2VuXBM53FVuvlSz6wfDi0K5HMzIkfURJuIhsj9fWzrtFCgIqvAmJm9HVFj9hsLBI9vgvFWN+vtFCxCPD0QDup2aUHvk121Wa/0PLDFKSuUW2P5luWN4MRo7K4STN0HSh0OhLmRcMo/WX6cRVQdq1MRHaJH39lJtvZH5sjOadSg03fQMa/jWUmEWTEoPxo4tZRf4zfHAu4DefRbihW5sX49WULpVw5TMpf/qmh+FDYSxXwL2m9YVfjY+pBEnbZsc9h768TV9OKz9/a4PH1/XMAHQidfSp
 VL4YaXTZ
 oq/iR+ffXATQRiOP0pXn2NsKgFnazx3L/K4MHg0GE6vW/DCYPzGENmmRUlK4U0PnqNVscsRmJvJNpEc0Dt8C4MfJoXBHEqilp4Btsoc3flR85WxIt9DAUVqcjZUvredcGinIJ0jEUZwDvnQMJcsuOkYk/RYHdI1jYA8WYEvLYxvWQo/7OTshr8E3Mog9qJDMo4S5XcddI+hTtuujlXSDroilmWMzmeGFbK7Uy41mb23lnBgPGeShsjEv0UGHghPHNfTUolV2S+Q4Ouu076p1MzITHsZnbxG/r/kvughT1DPiwhY2a8CCR5jsO65RUKs4tomUyIRY1Ps2SIqArfRoDMz1RR2CTZzJ3fqvPt8d007/j/p9EO1v5q4p8FfpMdEkPe/qphrYkPJ4daYyX1zlNkQvlEej61agpVa69B9VApjTuO7MLxAwouhtWGkBIejACxqvi4MndYcIefqdHkNAb6dcjdgvkNl6STKdOAQmqDT9GquekD9CYjUQQWx5PAMj5jmJkNNzkW/hzFGIGR97ftuStHKvYQRLeOPAEXtbnBfftwR8ggrJqa7bN0BxAcwiVO4lWZjeqn8M5Fl558tbK7V/iag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ian,

On Tue, 2026-10-27 at 07:11 +0800, Ian Kent wrote:
> Commit 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev
> in resume_store") looks like it's been around for a while so I
> assume the reproducer should work on 7.2.12?

Yes. That commit entered v6.5-rc1, so 7.2.12 contains the relevant
code.

I used the unmodified C reproducer linked from the syzbot report:

https://syzkaller.appspot.com/text?tag=ReproC&x=11c0f4c9580000

I also used the configuration provided with the report:

https://syzkaller.appspot.com/text?tag=KernelConfig&x=7d012d9c67977ee4

> What should I expect, a hang, it doesn't.

A permanent hang is not expected. The result to look for is this
lockdep warning in dmesg:

        WARNING: possible circular locking dependency detected
        ...
        &pipe->mutex --> &of->mutex --> &sbi->pipe_mutex

The reproducer records the first dependency by splicing into the
cgroup v1 devices.deny file. It records the opposite dependencies
through a normal write to /sys/power/resume. These operations use
different lock instances, so the exact reproducer reports a possible
cycle rather than deadlocking.

The write waits for an autofs daemon that never replies, but the C
wrapper kills the blocked child after five seconds and starts another
iteration. In my test the warning appeared in the first iteration.

The test needs lockdep and CONFIG_PROVE_LOCKING, the cgroup v1 devices
controller, autofs, and working hibernation support. It must also run
as root. Without lockdep, the program can appear to do nothing useful.

> Also it looks to me like the reproducer is trying exploit an
> invalid request similar to what I described earlier

Whether the string identifies a usable resume device is separate from
the autofs request. resume_store() first passes it to lookup_bdev(),
which performs a pathname lookup before the numeric fallback.

The reproducer changes its current directory to the root of a detached
indirect autofs mount. It then opens /sys/power/resume using an
absolute path and writes the relative name
"0x0000000004000921".

The resulting lookup is therefore:

        <autofs root>/0x0000000004000921

For autofs, this is an ordinary lookup of a new immediate child of the
indirect mount root, so it is a normal mount trigger. There is no
autofs mount under /sys/power.

In parallel, I am preparing a revised patch following Tejun's
suggestion. It disables splice for writable opens of
/sys/power/resume and gives its of->mutex a separate lockdep class.

If you send your autofs change, I can run the same reproducer against
it and check both the request and the lockdep warning.

Thanks,
Krystian

