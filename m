Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EF6606A339
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZmYByKkZ
Received: by kanga.kvack.org (Postfix)
	id 71A2C6B05BC; Mon,  9 Nov 2026 12:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC4D6B05BD; Mon,  9 Nov 2026 12:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BACA6B05BE; Mon,  9 Nov 2026 12:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 194256B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:35:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1F3840789
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:35:28 +0000 (UTC)
X-FDA: 85416282336.08.FEF6CAA
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id A35FF14000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:35:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZmYByKkZ;
	spf=pass (imf09.hostedemail.com: domain of nogikh@google.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794245726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7ipEMJZfKt5QXH9IG6GaoWGg4lbzb6pAGJlboFPwcQ=;
	b=JOCus4hOtzCyLbBv2+vPpmaYjszTVU++cGmdlUMUUU/PBUsh7hF5b0wTUsxtUIeJp4Cg8x
	0ekEqlK2ILGy08SXZDHi/ghPgh4gKCuhLq0g2HBIFsK+4MJtW5jfQFOdltAglI/o7cJp2g
	VEhIztYzxI4TF9PSGsZm+5dLtoMkjUo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZmYByKkZ;
	spf=pass (imf09.hostedemail.com: domain of nogikh@google.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794245726;
	b=KaMnfV6QEAqpCzGmyJ/3F0+j5oOpp5ZeCmziv0qb5MIyGVnY8YD5Kl4/8s1dHsXLexP3Nr
	VqitbJlfqhK8zykSM0Y97VFKLtobjmLomrvznvguRRZYSvr3ncHiBd71KH6DaQE4DdhKFg
	O7CWyJccAmGSDB+HG5cd+oFwMRRzYiM=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43bf9548df4so1326618fac.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 09:35:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794245725; cv=none;
        d=google.com; s=arc-20260327;
        b=IilnR35m37kvMi/npj/OpHLlhVh5Il7wl3lQA5/jtj+h6B5BjogGUwGMgu1YtOzLxz
         gfh89ckeoSY04tgGqXMbqjGDOOP3qr5M1grNUlgN6sZW3FTLTdcYe7MN+h5/CwxoNSL4
         /2lYjUjZ8hZGdSTC4Qdgj5cWXDJzSFjfUIJOLKaz940NVCjQ33dD3s+dioCNZQpmPKjO
         91sNz6ZDINXKs8Ae2MwJ05bMvzj1FrG4iWQF8+oSaTGfUBPesrne69o+KY0G1enzt4kH
         Vrr9DL8TgAJAT5qE4TPpQ3HM0YzBbYA4WxDcxj51fd4wIXHqJ0Fgl5nP22Pq8CIlcAFQ
         Yy0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l7ipEMJZfKt5QXH9IG6GaoWGg4lbzb6pAGJlboFPwcQ=;
        fh=bGM5XQ0H6KA4HxZqgagy4NzzLIOlicveltVXObnVXJo=;
        b=sNplGtahP533hwHDCDPJLwqSC0xLOepqVLIIdy/6XJh6vaQCaIYRx260GaSnhaIsXf
         sZh3Ht+2jxshTkxQvTTQWQ4r55w4b0cfvYVHNYkigMztH8UNRqt7gWcTAQXhyKhe2Hzv
         wbpTUtaJw7KJkKpg+BQe618H8qKA3VWB5l48YBNzCNF6GQXpPQTz1oTwf7q7w7loTOYD
         v3Wuz8GTL28/q/PhLYjlnZ1329i+3tmMZ1TWSVtmGJteogzpBPeZTKPwimbul0NVITwP
         EFIpvN7ipfLcSFEZA2gP6daJ0TmpaB72XjM4EK4sdvkDBpHW5Df60KTaalyOCln4gJLQ
         RdBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794245725; x=1794850525; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l7ipEMJZfKt5QXH9IG6GaoWGg4lbzb6pAGJlboFPwcQ=;
        b=ZmYByKkZdO80IW75iGLu++gwSPhNI+xcWHn1jL2WpE+u2kTQZqQ/YYCAZnM45tXRmA
         Ql8YtXwQAebiPJsRyd/0rXaudb3KMqNKT69IR63dmDzv1twPkGarYb7sgDx2VjotKoNe
         lduLDa72mAenF9jYvOUvpsnjLgpiRTiHbIwabVN/0NnTuyiuDv2tM6EDc+LrKpRO5kVp
         JCHeii4D7lhInyYMQBD7Ts38iuv/+AmcxLV52cWxGaiWff6Nu3qKPHBc544C/8xuJ/Zz
         ABnZjF6Up2t2MY7Wc+KcDvDHeEyTluhsGhJj4b7EWqSHtkpJMslzTP7k9NL/kSnu7S4V
         MEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794245725; x=1794850525;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l7ipEMJZfKt5QXH9IG6GaoWGg4lbzb6pAGJlboFPwcQ=;
        b=wujZNxfdTA8IFIBBOHYup8S+D2XpTp0b4TeKePPukLev5xlSHOxSZBnrwXg2WFGLcM
         Ss1S3qf++ZxaerwGgAjHfhANHISqRMlEYpDpeKnIqAnWvg3eGoP6KeDBG2kni8GtieO5
         Uz178MKwjxnF0ai6UUijMgM9pg90T9fcG40hT0c2fJcfrdJuCUS7LDjwlx8jyYIEwtrW
         wDYOWLRptkj2QxDGUs/h5I1cVaSXr69TouHEfmTzBaLsgiRVEZQDHMv3WV0X0tFLwIRC
         FnwddLGhflCQODFbDVM5LZaukQah9gsoWhQfP1xA3Fj8hsf+0gTf97gPLFESVkAanapV
         a4jw==
X-Forwarded-Encrypted: i=1; AL+hErEKIH/npQBV6L8ASIA0mp8Dn6/OOvSDHcXsJiwulREQhXctMd7X6B7MiJHwYF6s65g0pB4uABSAlg==@kvack.org
X-Gm-Message-State: APuU4Z/erhEdkkEn69hDx7zBgoXSse5IQ/4K5HFf6lTDoJ9D+rPKynsq
	MAUDnWJ2cSwcAcUFQoqYPn7P9QimJYuznpi1jrQK/yiZqRhalel15PmspUrYqMFwJXPaJUtYFLg
	Clgd5VWeiN1u7PPY3Q06d8ztlznCyMuUmmCYiS8kN
X-Gm-Gg: AYBFou3JQZdp7uzLAiPvzEyh6fdcPP0PHHWdzzskmqXFjOo4DvZpdJc77aogA1z5jxx
	+zjMLb1Z7bM7ldXkIFRjR6b4Cc50t6lsKBAuVaNwk0y5YrQAzSRsZXTaE+0zdRzEZo8okgIFRUY
	+3ohcnsapLuDaDcM2Q14g2SaPisPgk055nGQkBWoaQff91KzrztitMlnpIEMKQciV9VfTSUDSV1
	YP/ZpG4wFDorbMxulWjd9GvXGdLCNxGvI9xEAvD9GodTmEI7GZD10LXjrfvqa8T5aZBuJAVSb3X
	r+W1ZOif2rOhaQQiLZkHmY1UKW6snqEa61lV2CI+xAUO/kT3hCmigeu25ZCsp+KKMD9cUxSIoAW
	4bEy2jiu+3fDE2JnpwxWXv6+YsnqGFffnRcytM0lQpRWD5KcvdqUWXDr6K6FioskO1zGYKqJcVY
	u2oGATtEnZFVbvnEYPk6Wycy1lso/WyWZFjUX17PrlU+D7gEOIjuFqgIKhT8j5R0KpeRVVoyjsF
	iVe1SsE
X-Received: by 2002:a05:6808:1829:b0:543:50ad:baae with SMTP id
 5614622812f47-5683ce02157mr265411b6e.63.1794245725006; Mon, 09 Nov 2026
 09:35:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6af144ed.f50b2b3a.2c0de7.0010.GAE@google.com> <20261108202849.2e5c40a630e66dd39334a915@linux-foundation.org>
In-Reply-To: <20261108202849.2e5c40a630e66dd39334a915@linux-foundation.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 9 Nov 2026 18:35:13 +0100
X-Gm-Features: AclHuK-hI9rJRz-mT5ngogTQCjiUzkrA1dTOphNK2ymjlIr9_nFY1-IjXf1wnBo
Message-ID: <CANp29Y5m+47Y5n3Y8WvCEm2UgzGBOnpMK2eqY4aO1L+hQb1yNg@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [bluetooth?] BUG: unable to handle kernel NULL
 pointer dereference in __refill_objects_node
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+73e34786d639a8eb1324@syzkaller.appspotmail.com>, 
	bsegall@google.com, david@kernel.org, dietmar.eggemann@arm.com, 
	juri.lelli@redhat.com, kees@kernel.org, kprateek.nayak@amd.com, 
	liam@infradead.org, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	luiz.dentz@gmail.com, marcel@holtmann.org, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h31wwpqp5qsk6pady83kmrzeqtwmu7bp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A35FF14000C
X-HE-Tag: 1794245726-227937
X-HE-Meta: U2FsdGVkX1+R1/YJxDG4u6oMwULXkIYwaM2dPlos+nptez6/RrY+SmjCTiwkZ6V/yrAAfAKTyrHF+E/LVhyBR+9TR6LIcGN9YHc5NieMpZ4lbInBNsknfEDU9DrcT3P24io+DsqeJBXs8hGfsW8VTxfA1rHmtWgRrh+NogT2NW/W2fdxhwsSbvXovirEXwUvLq53AbcVD4G0pDIbA4MDUzwwLWECBdGffbR204kCs0XnlWuCXaXE6U45IA1gEPVO8wrpn+R6+VTcnbRx85nXnPZK5/k2+sPxFIGyCAT0ld6gUSpWOxgZs+ffHh/qI4c51d/AG7H8zrbVfBrzMSkTGYhiSpJLdz5vzFt6XLhNZAdElWD/e7s5aBLavmLQ3uEb5ul8qnC+sT3YNpnluX68DYRVuZJnOgDAP8pDhgZAJBRSVWuL9FHCUqJFWJleITze+dAwBaMXRgKzg9ddb6w5hFAKrTp+JJZoCGJNYpKebSkvZtyedOha4lqeW3gxqAHpkrxk345/n4KRqSFGNlnrEEBJscRHIIWxSjO0slw+yNTxoe5PYKlkqZ1yoUp1tvejsT7lCyIuBZ1GaLp8ClmJkcOHxA6NrCG1HDx5+AN5oVFSZd307YHOXvhy5H9p2qWA1mzfLRzU9fb4cVHQYEmJYm2jb97FMAaM1fvP3adyO6jtdzdTOQFNYnwEZATe2ATZB7d7viVrlvokdB4sd3XhAtYPWBEn729qRQrX82XpbXDe1nrq//NhqLaa43r+1EJcV8yVuhW24CXIiL99aoNLTmjxmG2D3apV7n4kxHkHhLYqD2IWEUc2RP+MYW5lgSAWbBKmeoOw+aF2ikorXw0NBzJ2biXnaFCad7BdmrKcj1spFg3NlNglRn5plTFhwhhjngPyTmX0O17m6weTR0TVCLNdgzncUKCeCVUeBzrFZDKo1/o3dyVctLeG6QU/qLJyuwdfwzsm0Q99CmOsasF
 gbCzp4BS
 0LnH1fURtSrVZWUaPrZyVZ8KLGIHzEzkjfQFoCDzvOsohAucJFS1L0SQez741M3FG75s1ImxX8XTRNSX8AAopKYLC7HqcDwZ5jRFmyJLLZTxRtYYNd/OZLnPkNjZDR4AJ5OX3O6pW49YO4/N1E66/hv3Q7qgLkOO9N7ariYC/ffI8Cu0viawJTvCB2GQqG8ztBTbieerLy4vXqFZfMykTYzf9peErVOIKPF9pMpx5HiuuVS69rHK1JsQ5mI/mYTkfXz54AN5Z1uJwUJXX+l0UMlzVuryxa4pUjFZBg4i9cm8AwB9q46TBeDt5NHvwciVConCMNminYfOTA5/02/IOEbGHNhHKKvsu8zyr0K3CoyeXON7/hn91NwH9izubINKZApfbmuix3daFRAjUNmii04Y+aiyTTLfpXjEFgJFsSN7WLxz4F+EeawqAfLgjtfnLHWJvwqvebYPfKhN7hosAh/BeB1n42A+BXiL2F0OvxrKdK+c6r0Hxbrs/J92ucRqT9Bv4xYEnRHuxQljSk+XEBrIXO4SoPWqOLWCMxK2Q0S5qk9ipo9uBOtUZI8GbbohWg3qGQJyh4zO05xZ/h68Z1BezvGUbzMzl01GQE5h75H6lkVAveQvbAJQ7OY5LnCH41YpPcW3B6DxuF1hIe1/yj0M8A3W16rJlIdsz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:28=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Sun, 08 Nov 2026 19:58:37 -0800 syzbot <syzbot+73e34786d639a8eb1324@sy=
zkaller.appspotmail.com> wrote:
>
> > syzbot found the following issue on:
> > AI-generated root cause summary:
> > In mm/slub.c, __refill_objects_node() replenishes percpu sheaves by det=
aching a
> > freelist from a partial slab via get_freelist_nofreeze() and iterating =
through
> > the freelist pointers in a while (count && refilled < max) loop. Becaus=
e the
> > loop condition only checks count and refilled rather than validating th=
at object
> > is non-NULL, a prematurely terminated or corrupted freelist (where fewe=
r objects
> > are linked in slab->freelist than the expected count =3D slab->objects =
-
> > slab->inuse) causes object to become NULL before count reaches zero. On=
 the
> > subsequent iteration, get_freepointer() dereferences NULL + s->offset (=
offset
> > 0x400 for kmalloc-2k), resulting in an immediate kernel NULL pointer de=
reference
> > crash at address 0x0000000000000400.
> >
> > full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3D73e34=
786d639a8eb1324
>
> Thanks.
>
> : This looks like a bad syzkaller test, not a Bluetooth bug. The
> : reproducer runs as root, opens the active PCI device's resource0
> : (mode 0600), and maps its register space writable. It then places
> : syscall arguments inside that mapping. On this GCE VM,
> : 0000:00:02.0 is the NVMe controller; its BAR contains live control
> : registers and queue doorbells.

Yeah, it's unfortunately a known problem.. Sorry for the noise.

I've just sent a PR[1] to prevent syzkaller from manipulating those interfa=
ces.
[1] https://github.com/google/syzkaller/pull/8111

> :
> : Both crash logs show NVMe completion ID and generation-counter
> : errors immediately before the SLUB fault. During minimization, the
> : same program produced crashes in several unrelated kernel paths,
> : including runs without the Bluetooth operation. This points to
> : disruption of the active NVMe device and subsequent corruption,
> : rather than a demonstrated SLUB or Bluetooth defect.
> :
> : The logs do not show the precise MMIO access or establish how the
> : freelist was damaged. Please rerun with the resource0 mapping
> : removed and the read buffer in ordinary memory. If the SLUB fault
> : persists without the NVMe errors, we can investigate it as a
> : separate kernel bug.
>

