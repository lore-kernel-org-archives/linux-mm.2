Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C01D606FAF7
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JUJ4cqvg
Received: by kanga.kvack.org (Postfix)
	id 534156B05B2; Tue,  3 Nov 2026 06:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C036B05B3; Tue,  3 Nov 2026 06:19:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422C76B05B5; Tue,  3 Nov 2026 06:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20AFF6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:19:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1953A0340
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:19:08 +0000 (UTC)
X-FDA: 85393561176.21.DD860A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 544BA180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:19:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JUJ4cqvg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793704746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GoGPgCpYCXIZ2TVcCltrAuHOCg1Xoc0aHaKBD0ahpDY=;
	b=JdPSEz5EnPxh7emlEQZF34lxHFcoPrsH39HFaUAvuDPg4cuEsP3JoBpMh01ggLhF66aO43
	Uf0XM9CB7/oQ69vFNNYp93LAZOTVXpGwGLfGXelDHy7TfD3hD5b9hVqLgJqnZJj9MMEzr7
	gmKkrfDJXUwrvyL3auyhUTV8/mJZBVM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JUJ4cqvg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793704746;
	b=MVX0Y2RHFCZCm9cIcCRg94yIqVE+DAlqu42eV+PKB0XtKcoy6LvU/4MibzRrloAJOtfZbQ
	6tpG0lwoyjLWMajyayh6Q48Bl2mSBv95SYnQVWBdOMfJOMwADM7HOF5Plx/jJURHplqyg8
	FjCs1kJhFOFPo5uwp33B6hjesmOYKyE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793704745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GoGPgCpYCXIZ2TVcCltrAuHOCg1Xoc0aHaKBD0ahpDY=;
	b=JUJ4cqvg7HIxCd1RC5B4xEyWu5aBvq6keFe4Xvk50F1l1aVZuibSrLf8HMQ2a7WjLljRo2
	b5G1vwTLHUEJxa7Ybp0QRRw3kKP8N52kIc5a0XaHn6kqqun6j2WeLsNN8tDfXz7Ehd2SV+
	IVtfr5GsHCsWrVGSO/ZbeVySJ15V274=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-QDV-Hd6pPT6vimL90vTfyA-1; Tue, 03 Nov 2026 06:19:04 -0500
X-MC-Unique: QDV-Hd6pPT6vimL90vTfyA-1
X-Mimecast-MFC-AGG-ID: QDV-Hd6pPT6vimL90vTfyA_1793704743
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b01a74792so2733971f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:19:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704743; x=1794309543;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GoGPgCpYCXIZ2TVcCltrAuHOCg1Xoc0aHaKBD0ahpDY=;
        b=P7umDi60KvjF7bL6W+9L8ovStn8nfHcmfQF359IBZ90nUHL0vCdJY4jqdZWjVmZFEN
         ikeq+vSx3lV2+2PvDEqcRtjq5sQ0t/rLXB4lYIqYq5mdJIGB3R61Ak7He9h84MlBI4TL
         T4+GsgletR/zh+AWxEx3GcFsgt3zDlL8SivG4ZATnhtjXcnef4RpuURM4DNEJJH3IXKT
         BgbQ48royyYJ8qoeNJhC7nEiOZWyGw8ZQIxoA32zRfW8Va4cS7jmIkJIj+5RHtNM14zS
         MIkvQBnh8s+KfNHKSN/jlLmNWOzrZfwL+Jtic9WZqMoNmA8EFbJVilpiq/gqqtT9TdQv
         fzoQ==
X-Forwarded-Encrypted: i=1; AKwUvBzHHIy4y2VyG3WBSVgv8UThtMBp0BHRewedA10Ml+0tuTvOz/BNc7J/4a6pw2hTEz9AG1IllXjb+w==@kvack.org
X-Gm-Message-State: APuU4Z82LRkjZn5Ohd4bTFVpPpX93vASRBSPprseM7SxhCBVZmBynrqe
	yaowLGDvFv+NLJkt3uEhUgw9j/2njvgqoIhfpet1954sO6EoTXQMHM8v+AFV1CAvyAGAQ4HpkZ0
	WkAlySZb0lxy709VJ6ZWqOsdKMGNrqtH5+YV211J2Apu4yvZDWnCat0ql+FkC6Ysh0G6KR9i8Ls
	cFNwsLI1f1r9yFHFH+i06AEGdih7Q=
X-Gm-Gg: AYBFou0D0JSM6qYp9z4a8wrat6s+fKjAqDdV3PpLJ7LpxOvLe0+XUca8yNg3Nr614RL
	5B8BOXHwBhbh0zde67f1oMZfwDoa4AxJYwRNxhc96ENRkalqosZJ63623ldIZ+hDu+fkN9ED/pR
	jK0+CH+mNZNN0m+KH/wnESYMDwArKOGQVwfhWlWChPToDYbsx4Uvcgwn6Hy6AdK4hznjxdZekZc
	ppj3HYx3vOPZ/7VcCgAQQl122Ab8s+cXkPQdCFvjDi6JdeaetsbWq8mFqsj
X-Received: by 2002:a05:6000:41c2:b0:48e:6f76:de9d with SMTP id ffacd0b85a97d-48e6f76f5e8mr28351838f8f.46.1793704742874;
        Tue, 03 Nov 2026 03:19:02 -0800 (PST)
X-Received: by 2002:a05:6000:41c2:b0:48e:6f76:de9d with SMTP id
 ffacd0b85a97d-48e6f76f5e8mr28351800f8f.46.1793704742539; Tue, 03 Nov 2026
 03:19:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6adf2939.67317f00.38c4bc.00ae.GAE@google.com> <20261026224305.1254-1-hdanton@sina.com>
 <auCucDdZb8mig7UZ@google.com> <auDvUyfzg6nLtVox@thinkstation>
 <20261027163929.2bb28d5b@gandalf.local.home> <aujLx1FOc12E72rF@google.com>
In-Reply-To: <aujLx1FOc12E72rF@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 3 Nov 2026 12:18:50 +0100
X-Gm-Features: AclHuK9TCKz_SldDuFHKUBahl0dpObHDrm8b0qWMqlbehXg4DMpHhR2Dfu-OUko
Message-ID: <CABgObfZ9mHj7Fsq7Z2S5vFy8R2Gkh2tHBATGJN2BpH=6Waks9w@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in __refill_objects_node
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Harry Yoo <harry@kernel.org>, 
	Hillf Danton <hdanton@sina.com>, Boqun Feng <boqun@kernel.org>, 
	syzbot <syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	linux-rt-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YugpOs_zHu6ZVl-JXoM1aC7ZcqnLYMGbc9CS2vANBxc_1793704743
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 544BA180006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5omzbi1kuwobf8919wiidcw56j3q9a1q
X-HE-Tag: 1793704746-801283
X-HE-Meta: U2FsdGVkX1/kqRPcV+Ch58ccuh/uZYO49f0/+2G06mWWZOtvTHWdcNQhjkvpV59ji7fpmeSAvEakdRt2/iZPptVtwsch5HXEPggPjK+NnkQMD1CnWzAOFh/2g+A7uD+4jW4iQjQzT4ks5lLC+b8aKI4gWTw0wlw/78L4QGb9tHwXJ4uqzXk1mwt+FokddFWBC9nw89mBHMBcAt6O6ZyphdAiWT/wPeQakjF/5Oi2h+KYx64f74sEiRQEWfDqdm4iID+iOum/ZcvdH9sFfrVDsY465keQ9m1EdaEqHE1pWRMIRrIjsXAOKWvertyBwIty10+Y4vBVZijkPBVoV7BSo/hINyKaZW+BiF/rt2KT2Wv2SLiPpm7NwoyEaUtpqT3DT9EQhnqPmuGpmyFpjwnWVSng6ZI9YDzvKkak+aHdFYyZgTYu5AqI/0Yk+qLO1MEkik3r5DmatbPvoJ9zdPOVMM90+HpYLgv50WfmCOCDSuR77vUSr5xEc9ryjM+6/w0YBhjj63rHQkiYHDRbYbUPAV32c0fOOjcdGMwlObM3U6gBr5C01ukd8l0WhW3Qvkz6Niko4yxOFqlai2vxe7/+rtCFnimjdKr0YAOjkVOnCzbiqMzXM8c4TPgT/oIhlLyF53r+8RX3zcHxgb7TxSIvNzDFBmk4W+E0I9d3vk7Vo4nc/qCr5YKHt6f8O6VPZyYdj1voz67161ZNJu6yAUdEQmVqL8aNoOqrH7jy0gGGlP3mqbgXOUo8TmuhCtXAL9B5pJnSXmU434cGCkEM3U3AC1pkaKgGqBhNjtf4Toi0Y4XXYPBucxdJnZs6Q6rTspW10tpqY/cB8Zzmq9Jn6lngf3YmS4SO6gTwXDz2LnEYWLf+QnUzaesjiCT8RLT5eNp/BJovdYwQuREzueU8pIyKfdKdZtIc0Rv6oR0/ciMq+fhCW3waBNcVqdZe0WrPaEQU71dM1lGoe1fHMVaNJpa
 GJ+aGvQ5
 JAPy3KmHyBIVCcL9lSsuRtZmU3ppbt3VWESqN64f2TISgHdJtpvVAyC/pyHbe54ykz8Iz1d9EnIoLQ6yJ4kd879DxQAKrFGnOjWM3j/8jWPXXif5X9goOWOX3lIXCdh2mSakmpWxg7VcwuRnAkFiJ8vgk+cCm29bulNeu3GqthF4fTJK7+FVWz845spqdulRCclqX6D1yhDPRDuPz7rDIHFWZ9smX96CubSC4k376SycW3t0Ycggu/ZfjEelTjRnMIxKAP6PNWVz5G0emDyUfrlOciraDCicfAOafWtrdeOnFJQHO+XwIVB2Mjx5T8067l8yv9iD559OKv4yVT5eNCwFl9ZT6jyl6L9jotSXin8ETAi0eo8WxGXlNfVP+kDDJkqpj2aFdVmy91VT0FUyhXHj3vTIJK2veWRua86d0LgroCNd44i95HnCkB+raC3f2NsHDVQQKNjLOn68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 6:43=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > If so, we need to make that a thread for RT kernels if you want to call
> > kzalloc_obj().
>
> Eww.  I can't imagine there's a sane usecase for memory overcommitting a =
real-time
> guest.

While I agree with the feeling, the dummy allocation path should be
mostly dead, because page fault should never (?) enable interrupts
before waiting:

#PF interrupt gate
  exc_page_fault()
    kvm_handle_async_pf()
      __kvm_handle_async_pf()
        irqentry_enter()
        kvm_async_pf_task_wait_schedule()
          kvm_async_pf_queue_task() <- registers waiter
          prepare_to_swait_exclusive()
          local_irq_enable()

The dummy allocation path is only reachable if it's an L1 hypervisor
that is getting an async page fault while L2 is running, because it
enables irq before the call to kvm_async_pf_task_wait_schedule(). I
think we can drop the dummy allocation for good, which would be even
better.

Whether you would still want to disable APF for RT kernels is up to you.

Paolo


