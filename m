Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C96DCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F886B00A2; Wed, 20 May 2026 14:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8676B00A3; Wed, 20 May 2026 14:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D2E6B00A4; Wed, 20 May 2026 14:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D13356B00A2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:45:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FFE31403A1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:45:27 +0000 (UTC)
X-FDA: 84788676294.07.29490BE
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7506C2000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:45:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ShyIxiU8;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779302725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8VRSe4a7rVhrbb1A8+5VusVTfPT4Ap9+gWJjpug488=;
	b=LKAcOOrxfF7NxooqsxiXxkYLVX4WbqYbHP6Q3ux7Rhwk2rRZPg51Va+vEi5mdtGvvreNxX
	A1gBlLh9tezZSJMfTSgid2q/ZcYCDKE+4AlJWyunTbZkJ/1EptQ2o6WWueNYYkvqbQI8br
	dhpSN+TnP4wvsBZoQG9IiKVJ5vDaXCw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ShyIxiU8;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779302725; a=rsa-sha256;
	cv=pass;
	b=jN8j5eL+uoQhMAWXEJeJapXLQYZ7f9kCL2+1ycwWHKu8y2igZ31n6PvJSYzf8d1F5WPBVH
	aD4/priR59xFMhDi1hpUW7m2yE1JMon2/unrROx7qplmEPNbr65dpC6fem2mwvZhAwh6vK
	gF0DhlM3lN1NF295InyBtg2k12EqrMA=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so171a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779302724; cv=none;
        d=google.com; s=arc-20240605;
        b=lpCbq8AgjrsvKv/YPYylenp8my9nwdxriANmsulTU8kodYlGTldOPphiCB5MDk6VbM
         tVOqY94vbj5qfVZD+JvfCVZ4UrFtLvdsymY3jdFA9dsXMX/3Yd5n1Kh3vfyUK+koTKxa
         bE1XaEOs3vb+ULsHZyqRa7rs9fJBI6fL/h8kb3OJ/wgd6IWR2Bm23oU3ANooUjdeiqP2
         4CiOp4L+IYceyWpHMtwOds8ngOMycbaQcme0riHedrgrk/nD0j0Bcy+aFZLdd653fPRc
         J0Tl9J+HRgBU/uST9OkfgNhJLz0Bqcu+u0bF/rwDhOOEj0/EunhBbJ0ZxpDxkHyf9sQF
         gdmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k8VRSe4a7rVhrbb1A8+5VusVTfPT4Ap9+gWJjpug488=;
        fh=zfFmpEzUTet3nQf596f2TVmRl8z8DR0/+NAH11g1O9Y=;
        b=QCFSPHh8DJqdwD2KpQ6D73q4ohjGcTpdc5qvLcgix9mD3uE24/BXEtrDW0L97uaqXX
         c/xaSHlpsFAZawzisRIuAS3muuJ4XPMKYIY7Di+ohOo29iBkJL8y+uJLfmUD/k8wO8HN
         BCG2R2B1wi2J5ShVeEK7I/J3UsqS0TlTI3fWwJwzgffnK2BLcNXovgwBmS8QxE/byc1Z
         ggvc7yQDAsksxlp8qg558Orfx5bI/Amsc8NOrqU/uym3ShH4hebGgva4wg284ts6/PM5
         i+uTqau70SXlROPCqdQSRn+AR+WenQFv5ekyOUb/yjxN4Hwmw9MmoTNex1UsfHEbLnH1
         GwXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779302724; x=1779907524; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8VRSe4a7rVhrbb1A8+5VusVTfPT4Ap9+gWJjpug488=;
        b=ShyIxiU8qyYcF0DrF3w8yqmfe1ks71qxci565OxBonKaNBYbw3Nmx61ZWsEVwD5vaf
         Mhxm2fBBmUtVPS1brgPWMyExIStvrIgwVh5AiEtSDDvp3VoMgfpL50pSgd8FUs5TiZ6M
         ff8tow08xgm0ke9u44GjEJi6KpOk2UrAE9hej2Zgf1tubq+B30qUb4dhwuWPtUFTYeuY
         M1djXTO1EdqWEFROYbea5ZgjBZS3DrkfkSLESHPHYmEMXdPzR/RG1w3D+bF0q3slzux4
         QY/+vjGIrC9/MbhuCA3JidlY2h/mFFJPjdh60AgvYBHMaT8ubYtj71dO9rhfbgnc7gyH
         jjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779302724; x=1779907524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k8VRSe4a7rVhrbb1A8+5VusVTfPT4Ap9+gWJjpug488=;
        b=hJy/f0TGUaGN0uIP4e7Zr6Kdhdm4Q4CVQBTVMcbXYI68ApE1op2jsHdTAUMS/xb97+
         PmBb3vuEYjwKEhcNY1dX31wkLvDSPuuJpl8A1uySGyLyqZuepAUu24fNMvAuOzuV6KjH
         fC2GGpHtHG3GZyTwg7Iv5vgB5TC6HiCTWAm7qVEBmJVVVZeudkll5FaL1jBy8+oYRLrv
         3HzfPa92Pulz8kM8zLFMlT1Lx3OQ20b5vVQ6Xl5EIJlmfYTqIXwDErMAUIT2t58bIpLF
         Js3MQWFZktDP+84yt9PaRptDhzg5SAiRpV2bPnRT+e9QcnnFIQJYqHYHXTd2Tak5fSGz
         AZ4A==
X-Forwarded-Encrypted: i=1; AFNElJ9HWpj+Q6s7n17he6Ex1QzYjjwKdJ1yDMgoV2kEryBGx1k+XkJVwt74XiqrK9TpqpZNXS87y5awjw==@kvack.org
X-Gm-Message-State: AOJu0Yw/Tk/nO0UHQ0PKEtiszkNlE/c1nAFcaCCCmC07oT5gOzw/CRny
	E9iYEjW9q6L0h99ZBvtf0jDYUeCEMwcpKfQJNRqJajhaT1FOIPm8AGjGa0bZlAqyQT1X0GWCg+x
	liHyMMYVEbqZSHo2R6o0BgtFEYX7g4QlPmaXBzkzcNH8P4pwlI5mjbYsFxY4=
X-Gm-Gg: Acq92OFPdw3Td8Md6sKNVMapcN0G/JdNn+iRMNAzKH/eVOjFMctc0qJReBt9cBVI+gO
	uA7YB9E5REMnACFeJSBq7R1nhjvsVjY8uADP1rYv3bAgofawofJuXBffBCGA4wVzWvrtRL1hB6H
	f5NlWioRLQVLg56Y+fNY1r8mj8r3j/TSagnx5KIbyo1OKhF713JOf1up9XEOGlu/0ly20z6UTJ0
	kLl96BqveyBFfkBQVrvclVPSaIGec6LRyPqY3JvWHeZzD6YA/BP5760ateMti3P3F13+LbB8tzt
	OwmEPIw05WEu9qzxZV2ZWa/K2PHxAfTtroiFObvDI/fok8Cc
X-Received: by 2002:a05:6402:8cb:b0:67c:f3b6:5fef with SMTP id
 4fb4d7f45d1cf-6880364b102mr9600a12.6.1779302723413; Wed, 20 May 2026 11:45:23
 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <20260520-work-task_exec_state-v2-5-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-5-9ea88ceb09e6@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 20:44:47 +0200
X-Gm-Features: AVHnY4Ip08KLxlFSIOoTlLb6zeyGy4QsFp4x-bCaClb5UkJ0Tpz5hw3eB-kWt_8
Message-ID: <CAG48ez3DCVH9T_Q4RE03wvZ76YLni46tq98ppC48EZatL6PDew@mail.gmail.com>
Subject: Re: [PATCH RFC v2 5/5] cred: switch dumpability lowering to task_exec_state
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sb3uswttuq8ysfaagu67g95mtw4hxhww
X-Rspamd-Queue-Id: 7506C2000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779302725-112035
X-HE-Meta: U2FsdGVkX1+8Q6MBhlRv4qkTe3pXMIz/SnWXjOhBN73fxdU6Eo66QAxG8xHeqpWLcpaam9UUi57JwZAjqY8ML+OsHwX8y8sJDjZvitgL6LaNMyPcosU5er22dvVwVyquawaSPE8txofkDgdMWT6ZkQXC5k3zHqVnl1aQ0xoRZrnpIhmvWnShZklTvHJTYnWZII5DQJqQcUlfK8dToWa6hVSss943fzh/jkM6r1F1W6pQLx5qb4PEeUqsqBFfT2EC6Er1AfUEzbfn7nAlk3C4zTFFSpbtK6rfQO94uA5m5Qzrwm17oR5DSU+UfGrdGMNtnNheY6dfS4RbkG7FiBIUUx9ObjilCJuiRsJ4tc+pt+x5Gov+QyqKIMssHYkvjSrURTlABC8AXK+S50UtQpRE50qyq0zWwcghSrxKYr8m/3tYct3J6ndV1mPwuGfrYDi/o1aASEPo/6Wrlvh4BGPAFBK7fB6gjECpJzUXavztIHgktf6k6LL8AB5lZcCyubbgu7tIpfEnbnjIKeQTi7AlVMST+vBQgam4L5X7xLdXxC0NVS2NK+3Z+VUb/SylRZFPi4+MNdynQPC95bkNP/TeEr1NVhdDFBTg9eOxBw/MbJ4SAdzbiJo3l0mll1lHiQiklRpfAEJWiIBxWIXVEAtC+fhAD3jJ4zh0IZ0DD6yvf74frVoivBvzP7Pu8wRKVTKvygNX9l8iStWZTiwTprk1MX+UX8GZdxdTAhq1y/gmp5zjAI1282g3svJnnFf1IJLQ2Q0eesUwMVrZIc3oDTBl6BvJmSnncekVDPerdSFyUFRksFqfETnlxtpD0CXnbb5enQxUi6TLvknvreZkpuTJSq/t22DeEJ6CH+SXkw2+Zuou1MLtnsuK4hYBKGUOTw/N+RKN5ydmsYEPHUapNeFcyEmuiINqFCSWxAkb/sQxp1bte/lyxqpCG49+Diug2dgRA5b7/zSQ8ZzkHbs47nk
 kF3X2BwQ
 KzXC3vmNGies3hJjk1Q6ImB+lotzrGBJ0fkSU3Xd0RFf/Rylbp8XnS9MUrnBsujkyfSJlva04gkKBJrDZY15934sg6Kw0qgX63gRhml/2+YogkTyyIT8RqkzymtMYVkdtb5g+ihE/ai/kmAsxhipkiRfquIhFgRiQ0SbrT5ePmgdeTkRwXMVjHZZLaFlXNwTo3qzPOLq+hxbcjaiQmIePE8wDd9IntjrzaPvaN7RakEycKKNdDEEdJU5yEpqpmjsf+Zs9/EMi/cqUmwrweKLGTnMn5LFU6sEASB/DfyV04LEUnWxHoU3AQM6TfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 4:43=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> commit_creds() has historically called set_dumpable(suid_dumpable) on
> every effective uid/gid/cap change, paired with an smp_wmb()/smp_rmb()
> fence against __ptrace_may_access() reading the credentials.
>
> Switch the call to task_exec_state_set_dumpable() so the dumpability
> lowering targets the new per-task exec_state rather than mm->flags.
> Drop the open-coded "if (task->mm)" guard - exec_state is always
> allocated for any observable task - and drop the explicit
> smp_wmb()/smp_rmb() pair: the new model relies on RCU acquire/release

RCU isn't ACQUIRE/RELEASE; RCU is CONSUME/RELEASE, which is weaker on
the reader side.

(While ACQUIRE orders against following loads, CONSUME only orders
against following loads with an address dependency, and is implemented
as a plain load on anything other than alpha. It's a bit cursed
because the compiler doesn't understand the invariants that must be
preserved for CONSUME, which can cause compiler optimizations to break
CONSUME ordering if you're not extra careful, which is why arm64
builds with LTO do a memory barrier on every READ_ONCE()...)

> on the cred pointer.  WRITE_ONCE() on es->dumpable inside
> task_exec_state_set_dumpable() happens-before rcu_assign_pointer() of

Yes.

> the new cred in commit_creds(), so a reader that observes the new
> cred via rcu_dereference(task->real_cred) in __ptrace_may_access() is
> guaranteed to observe the new dumpable via READ_ONCE(es->dumpable).

No, the two loads in __ptrace_may_access() are effectively both just
READ_ONCE(), which only provides RELAXED or CONSUME semantics, while
you'd need ACQUIRE to order this:

__task_cred
  rcu_dereference
    rcu_dereference_check
      __rcu_dereference_check
        READ_ONCE
[...]
task_still_dumpable
  [...]
  task_exec_state_rcu
    rcu_dereference
      rcu_dereference_check
        __rcu_dereference_check
          READ_ONCE

