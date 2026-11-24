Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529BF606A339
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 06:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nnQrykAd
Received: by kanga.kvack.org (Postfix)
	id D1DCF6B05F8; Tue, 24 Nov 2026 01:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB466B05F9; Tue, 24 Nov 2026 01:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9C26B05FA; Tue, 24 Nov 2026 01:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83E996B05F8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:00:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A223C0AED
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:00:53 +0000 (UTC)
X-FDA: 85468963986.29.3A03445
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB57D80006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:00:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nnQrykAd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795500051;
	b=NR+w3iHB4Rtd7RVImfve4DvKi62H1S1Y2l4rJVzCmtWbkbykwMyobt7F1OrTIPJblacGyb
	H/ed+0vnW6cV0PE03qijEeLwsoFymzqRn94K1lnIzTR+G/mks4exYp+D5ZIBhGHv79gaBq
	+tnxpSmP8+eBvBKqlVgYTwqZ/u0Th4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795500051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SLHfkNsrCjSRx5Wz9p+DTV861mq73QFj5nkNZKg5lU=;
	b=MdMTsovSBgbs9awXjWYwx/0Rvm/7LqeohZQqDIKxTgez7bKT7FxhnH8qbT6+nwMZiPZbXS
	0HlktL5IGfypm2vsyOtk5W4ihiLezgOBS2GNi5INl6M40xZlgZ/Q47ih3UPN1/rY2O3v9M
	igZ7MjzGb9e1coqsdJdcm0fa4kIM5t8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nnQrykAd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a9f9473029so3080236b3a.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795500050; x=1796104850; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/SLHfkNsrCjSRx5Wz9p+DTV861mq73QFj5nkNZKg5lU=;
        b=nnQrykAdegiih0glB3fdqG7spJVr+54heYjQXLTjN34QEsrMncaWDhXCccnGwFeDPs
         DlG4jPz+3Pa1Ud9M8PwzaU5aGRImS87Jw3e8baVjAxF5xjtyQhsftuLkKPfHg5TKn31j
         aLiAWkPOhcSi+PBATDoUqavXLNgLHW52Js0vcYamalZM0saM4mI0r7nKbh7dqOifgSwf
         QwEkC7WwRSI4EIK0uEchbI7u+hmiMRJEKX2BsszyGgM8mjRQoiTLI2B27TC8tIIsPkqN
         ji/nPAc7QuyKDiq7KjE2PGYzx0vJeFht6FQUvSNeO3hEeYdAi6N2kMAt5+IgenIgFHNR
         Tl1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795500050; x=1796104850;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/SLHfkNsrCjSRx5Wz9p+DTV861mq73QFj5nkNZKg5lU=;
        b=Zvb9+8OLqG1EL2DN5qYd2SYbEdunvDzX3leebQORCbUILqimlfKwj/8GCo9/cOQqpr
         AJsah7Rx7ajnARhaPecABGAgpTM8WLF4p2eBvb3BTlgsWOnwZvFUAX7obwzKmSJ40LxP
         8V7TS+2lgePGsn8OLXJ6JnPzWa5dHEeZWMlGIpbhvIi0OmxewfP8EPdsQXaJ/ULzUPk1
         PkoC7IH+6b2KIcZlcONrz7dhL3fDBaS9tZ0baCsSfswvHN2W4QLcczefq+f+PWfj5N+J
         rUzOrslif45XoDViB1f22xnPPbVp1dN35lLV29aGo2DdWQWbbu+eLAg8RP7Rf6wIG3mn
         XGgA==
X-Forwarded-Encrypted: i=1; AL+hErEia7RUXBD5WwVHVLkgAMJ5w9kICORckHbVpt96g0tBcJpxzGBjMBdQTQCrqFEcW71Y62y0kR6W2w==@kvack.org
X-Gm-Message-State: APuU4Z+8oTfoYBoXTTPnJ9prfd8hf/MKp1pt/OXmaaBHmziuNQ7X0WJh
	zrzwJNY5ZWWq5dNvB1O8ARc3VKhCC/E6DFJnzoBD3g0oJ23oK8OEgMcI
X-Gm-Gg: AZFdTZeBNPKmVxjjYjjW1lb66/FmWkctewPMJYBG1SbZwVnz2kpulFIjskQtazt63am
	AYMfTQgL0HfcrYksu2Eakjh2eODtb14VKZmrxSBRbSBrvJxwztquxxjk1B/fL780l+Wksq52Xp6
	CyqN48uFyJ76MUbEWLrsOt6mxLjdDrrc007vMlI1t21GCQFNfjvZl6IebOoSjKbnMFWHcyN8Wnx
	YiwyP+l9pA6tOd50N4SgJS8Qei08bX735BLSzxfCeOcRL3w/AC9bwqKXjWX3dDbTpMk+c7g2f8M
	Kj9Ion+KWeiugn4HLB04w3kx91rEXHjkGWg5F4+l6hkA0jMvP9HToexkL0R2Mwx8chO/VlfGYa9
	xli17YtW+qTsL2E+JhOdtUXcZSmrUO0VZ/HXZnhrYsY3KWTuKLX+io4zwvyHMemtGJ0Lv7ViuhK
	QpZ21o/Bc5S3/eshAIQj8CjLZ77j12BF0eK9F/OW2WJV1PPItHKhjPMHYCiWXodU6pXJfn9aPbc
	3ys7ZSS919kLIyDVWPpTa00Mq/OU3vQQ7j5HSdooZWAMa8pqGv9Q/VB6/FGrsnnF31aXVG1S2yi
	jDkl/mFOHF7JGVfdd4CNKe/Ds8/jHY1w/26+eFSvLJg+ZX9bxemyNg6afEJMcoFMRfmQWobA4pc
	DA0DyqjwqRgptCRm6dwrPvy8I59RqWAKUhF0=
X-Received: by 2002:a05:6a21:780a:b0:3e2:8b64:2ca0 with SMTP id adf61e73a8af0-4014d35f1bamr11982201637.49.1795500050075;
        Mon, 23 Nov 2026 22:00:50 -0800 (PST)
Received: from localhost ([153.61.198.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d03adafsm6596544a12.23.2026.11.23.22.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 22:00:49 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 06:00:49 +0000
Message-Id: <DN37NBGPJJG9.2DSVDCKS3UYTV@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "syzbot" <syzbot+b6f8640465bdf47ca708@syzkaller.appspotmail.com>,
 <akpm@linux-foundation.org>, <andrii@kernel.org>, <bpf@vger.kernel.org>,
 <brauner@kernel.org>, <daniel@iogearbox.net>, <jack@suse.cz>,
 <jmorris@namei.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
 <paul@paul-moore.com>, <penguin-kernel@I-love.SAKURA.ne.jp>,
 <serge@hallyn.com>, <syzkaller-bugs@googlegroups.com>,
 <takedakn@nttdata.co.jp>, <jhs@mojatatu.com>, <netdev@vger.kernel.org>,
 <tomoyo-users_en@lists.sourceforge.net>, <viro@zeniv.linux.org.uk>
Subject: net: act_gate bug. was: [syzbot] [tomoyo?] [mm?] INFO: rcu detected
 stall in security_file_ioctl (9)
In-Reply-To: <6b051681.58b41460.7037.0590.GAE@google.com>
References: <6b051681.58b41460.7037.0590.GAE@google.com>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: CB57D80006
X-Stat-Signature: 7qtfiizbjxi16qyjfufmfi1suaox8tnh
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795500051-263319
X-HE-Meta: U2FsdGVkX1+31l7K+PbL/MZfopMO02hn4fibeWlLd8dzAO1BcjOB84VOdbjs60F0WDsSo2AFEkTnRzIMWCVc+1yHIgQKHRBn7otqgDogc2c0jQ++kz2Lhf0LfOTDHYBowiysOfXRNrQwdyLAZpkxXQQFZH+cCLEzlxV3LfBIyqYVShFRCfqGt4rcDb/+cFU4TKRKZruh7kDgsY2U+ulW8OLEgygiGwRsTsBA0dhAyxPKCod4r4zat3blDGT95MmRKXD1amWZW4r7v/lmRK72RRMDVD1wQU3mBaTbSME0X+O80iwc67W6x6l9EIjMrM6DrNMzS8aLGoWWJ3X3CJmoxRxp6m+ee0pFGNxkfXHfdDOWIjkV/efK+WU9FWJrl2tLUYAM36Uw0vcYjKodaqBh7c9M5D9QkVmyYhEQiAcLFG/Z3BNp8PpFbix/f23b4elBcdtyRjk6CA4b5hlQJlW2Ok9qWkacGJ+tcGKj2X4s+qWhifzpO5cIXp2/de4L2qzsj9TGcDZ3Fk6FlfjxHZwgGEeoRWHJU2JlnWqBrhQRflpyxV8ng5jbCZxwGjMtXMEdiBAZFtDK4zD2oxQ2PiMaAlOK4HVYQ9lLc43vtqLj/lQ9JDnDvVb+nSPci9rYYU2K0aspf3TvPoulx0/2vnFkDehWhwg+Dj0G1/p+IDRfOSIQVmbuxZJEUx3YbBr1VEe+5CXKZcWbifKtqOFWmBSuP0QGLZk+lBRMhSHZD/SJRjApn/h+CBs8YByXad7hgdj8j9rVqcylS47Mn3BKcmibMU/el+ulOOqnO7losViit195horHea0tF4PVG8GWcObeDtjS9LrjwSv/aBPKMFGD00WywADarcBM0FB3HamoudgKLnllaoxCYcjL3plShwXu/F8zKkg91fG2G9eoZmLv+UXtRsFUipugtd/bQgGXodDf9wnU+LxdmxMc35nXBFVOdiIUzkN6nDHS/JpW77c
 Otsswqvw
 EwlVDZ/FdGHS5iEjze11q1jSGpsNYDO5Cz5/tke3JXqc9GwKXHxh6/GUWd/JIXfp6nw3Jm4QP7vgODGy6YSOOr+GUxqTibC1jQH4nAm58Wv1yZ3Kp8viZJrwDtJtmvrfx1QwtGQhMZO0Autecwqj6z1yEus0f8GrAXKW5/8u76ajBoDfixjGds0hA8/sfqdLaU4ZswqGYGBtBeEh4wqQ6RWMUWaSDSx+Js1K7l7jDXYi5eRGGkrgv3bnaK/SeeWx1ErAQ0ebsPIRaZ36fISGDaqh0SYLUN+0xlyQBYHCmbulGXdeJXs5dvMNBPGEio5/TyWL0pNaT1AS2Wu/AOBqnJ0cq8c7GL+harl554PV3B6HImBBLBna5vvXRzdjBQVkXOkmvaEpK2lJfKVTE4PVjytPJe77YlCFZnBh7KsUzV/jNEVSaN4rmyb4dmzu0cGx2fzekRadNsVMIp7D1dTfJuRrjHlrMa6n7PYeLm2O4KG9fjiN7412zOsJPx+jQj6iq4rttI+MWPZl+BIdJSDdn+z6xg1uXWPecpj/FqCBE3QcRa+Er+PFzbBoQXbaCovjBsHDoBhY/STZHmffFXb+L1ls7RcoENGKT9jv9+h9eawBqMpv33udn4ekfeAOB7ax52R3ZhkeB2p34a4a7ggn98tVpnf+rgK34wlpbp4nEeVJ/A7BXhZQ0CCPQ4EpHJKbcyE9h0BZuBA5MsmNzrk8hwCuAMNtR1K2YCqSxlg0uBiiGlW5m60d4Pxvadz2Dd+tAd0cgqt0zbFvybk1zTrBxMQ2nXiKnO7lFVWKR5xLPTTavmj7gG3woFY4efwp9BX5h95WSX2EhF38Eet6G4ZzPlg1i6b6pXKYzyiBJujrZQfGEcNWUabwHB1LB8XRwlZqy0qM8+Nh27yMZV1FNa3NjT6wnOvCprHMwoXKKhbfqYIC9bW034VyGlgs1PELoiZQRZ1aWXvcSFzpbQCwsuhNDDckTVcDX
 qVhgPVb9
 mDUyMq7mE+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 08:45 PM syzbot <syzbot+b6f8640465bdf47ca708@syzkaller.appspotmail.com> wrote:
> rcu: 	         hardirqs   softirqs   csw/system
> rcu: 	 number:     5264          0            0
> rcu: 	cputime:      138      52351           25   ==> 52490(ms)

It's not tomoyo, mm or bpf. Looks like act_gate.
Zero new softirqs in 52 sec, so one hrtimer_run_softirq() doesn't return.

> RBP: ffff88807ed35538 R08: ffffffff91be1bbf R09: 1ffffffff237c377
> R10: dffffc0000000000 R11: fffffbfff237c378 R12: ffff8880b8228600
> R13: ffffffff89fd0480 R14: ffff8880b8228600 R15: 1ffff1101704514a

The registers with lockdep struct sizes:

  reg       value             points to
  --------  ----------------  --------------------------------------
  R14       ffff8880b8228600  cpu_base
  R15 << 3  ffff8880b8228a50  clock_base[HRTIMER_BASE_TAI_SOFT].seq
  RBP       ffff88807ed35538  kmalloc-512 + 0x138, tcf_gate->hitimer

act_gate has the only soft hrtimer that can be on CLOCK_TAI.
bpf_timer_init() rejects that clock.

TCA_GATE_CYCLE_TIME is an unchecked u64. In gate_timer_func():

  n = div64_u64(ktime_sub_ns(now, base), cycle);
  close_time = ktime_add_ns(base, (n + 1) * cycle);

With base = 0 and cycle = U64_MAX, n is 0 and close_time is -1.
The timer restarts in the past and __hrtimer_run_queues() runs it again.
It's there since
commit a51c328df310 ("net: qos: introduce a gate control flow action").

Jamal,
taprio's INT_MAX limit doesn't fit. tdc uses cycle-time of 600 sec.
The diff saturates the sum instead.
Here is a potential fix:

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 711cf24..5422d60 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -45,8 +45,9 @@ static void gate_get_start_time(struct tcf_gate *gact,
 				const struct tcf_gate_params *param,
 				ktime_t *start)
 {
-	ktime_t now, base, cycle;
-	u64 n;
+	u64 cycle = param->tcfg_cycletime;
+	ktime_t now, base;
+	u64 rem;
 
 	base = ns_to_ktime(param->tcfg_basetime);
 	now = gate_get_time(gact);
@@ -56,10 +57,9 @@ static void gate_get_start_time(struct tcf_gate *gact,
 		return;
 	}
 
-	cycle = param->tcfg_cycletime;
-
-	n = div64_u64(ktime_sub_ns(now, base), cycle);
-	*start = ktime_add_ns(base, (n + 1) * cycle);
+	/* cycle is an unchecked u64, the sum must not wrap into the past */
+	div64_u64_rem(ktime_sub(now, base), cycle, &rem);
+	*start = ktime_add_safe(now, cycle - rem);
 }
 
 static void gate_start_timer(struct tcf_gate *gact, ktime_t start)
@@ -107,15 +107,8 @@ static enum hrtimer_restart gate_timer_func(struct hrtimer *timer)
 
 	now = gate_get_time(gact);
 
-	if (ktime_after(now, close_time)) {
-		ktime_t cycle, base;
-		u64 n;
-
-		cycle = p->tcfg_cycletime;
-		base = ns_to_ktime(p->tcfg_basetime);
-		n = div64_u64(ktime_sub_ns(now, base), cycle);
-		close_time = ktime_add_ns(base, (n + 1) * cycle);
-	}
+	if (ktime_after(now, close_time))
+		gate_get_start_time(gact, p, &close_time);
 
 	gact->next_entry = next;
 

