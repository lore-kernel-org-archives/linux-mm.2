Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5D0CA0EE1
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47238E017D; Tue, 12 Aug 2025 13:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E278E0168; Tue, 12 Aug 2025 13:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B1F8E017D; Tue, 12 Aug 2025 13:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93B398E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:31:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41863134705
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:31:14 +0000 (UTC)
X-FDA: 83768796468.08.A025AA8
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40BD1A0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:31:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vnd4xMPr;
	spf=pass (imf25.hostedemail.com: domain of 3XnqbaAgKCA0wnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3XnqbaAgKCA0wnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755019872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lO6uMK6KqC6CFZuyBdorrbdUmeFcwW7b40ufzsbZ7fI=;
	b=frbYbFMxLWZFXA5//DBpuopbXpMFLhKVUQpgnx8MQsOmfRLgsepY2TNkjkf5gZkrZEz7TY
	12pmTtEKe/Tuyp9FQVS2vZDqpX8OsBUfdpxNJQwRIeDyw/bvwTXyZZ/fLDfxc/E7yIF0cE
	PNC60inySnam7k5ecyAGOKQ07Wz3rKk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vnd4xMPr;
	spf=pass (imf25.hostedemail.com: domain of 3XnqbaAgKCA0wnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3XnqbaAgKCA0wnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755019872; a=rsa-sha256;
	cv=none;
	b=l/2s4+/TEk0Y416VZ4ZWFofGn08gT8EBY5Zp1Nfpy1vfyNnOizHYqTb+EnqC5IoXFB2N0K
	KUcsy+/Q1klRlx/41XvUIkV6kmkUIcFIY+rOJizDKcbF/3aRX1iiK56lGzPKnPr8UiEfON
	MQyrKHB5Nc5bi0HnVoAPrN/G8+miZOo=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-61812f3dcadso2548762a12.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755019870; x=1755624670; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lO6uMK6KqC6CFZuyBdorrbdUmeFcwW7b40ufzsbZ7fI=;
        b=vnd4xMPrysJgTYSOmTu92lJVgTB6Rw7a/o6phzfv844i+la0p5dGksb60DbwKPvrDr
         i8cqcJlreJ2VxPwD4Ongu3Cvn6GddSRwRM/aBRJw8oYY/MuBXEdaN/TxJhz9pUdqoPEp
         3PpIOYSabwUHHTmt0aygTxVLanRNUXfZqktQSxFVF6cG/84iXm9jTd/+u8Ic8SnK3SlM
         Ig3YJJBvLRMRS+ITvZVxGZqL/W/FSYRHgzoNQ3Jw9Xp0Z92QnBoDZjaInIBOA5yzjd98
         2AONThqXp7hdNN+tNw8x5wgGH5QjEDg8gGy8CKK1ygCMZ6F0AceILrn1zNj/MV9M2UCM
         yW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019870; x=1755624670;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lO6uMK6KqC6CFZuyBdorrbdUmeFcwW7b40ufzsbZ7fI=;
        b=gZF3a49lCyL7hEIytdKII2rKH9dzBduNqRNab92rMc2f4Zc/RKIsYsxxvdKF83YFrY
         u4FbtgE8KeX9iWDm9uR+9GmRbec73/5lbPH6aFdRW/UJS92vXymsTFi8anBq5cEAjlSo
         yFi/0kGuQnVOs7XLb9PmKrUoEp7+SKimEhKxYOTnZD4r1mpxyQOUxZJyoS3UetRI5bZ5
         Q24z5T63odwoM2eSt05HuTigtzCaZtHgjwfZnSznq7tScM4XYSzfOc0JPodw1xfbWRCG
         XCiJG6EzWDj1Osy951j3Dn0YVx0LvCcIaVJFmAjF84C+DjxKAVLnmQo66HaSBbuJ96XB
         rYpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv+TlmUo9MGCDLwQWXSMz7GCchP6Kd7mQ9lwF3FJbBdQgPFvNw0k2Os6+txbIQEWKfEkZc+KA6Bw==@kvack.org
X-Gm-Message-State: AOJu0Yx8QEgx+CClwcYG/7D1I5J5fC7rUJVVbLDcaPWG4fkl3uhMp5MG
	v60QzM7bJmDSAi+uq2yPQHCb6rNUbMHQzZaqMCz5Pcpo1pgbQ/KnJFL/oFU0puXQQTr1rtzlZEU
	wWdasYeB8Qhxvgw==
X-Google-Smtp-Source: AGHT+IHuOuZawFVGmekchOLH7kWCMsK75iTZ+VH3GUhVjBoKVF3OEwrT4z3YtZPGKaHMJNDsnXxZGvmX+COMAQ==
X-Received: from edbev17.prod.google.com ([2002:a05:6402:5411:b0:615:4d05:f4be])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:40d6:b0:617:5be3:bba9 with SMTP id 4fb4d7f45d1cf-6186784e879mr581207a12.22.1755019870260;
 Tue, 12 Aug 2025 10:31:10 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:31:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1
Message-ID: <20250812173109.295750-1-jackmanb@google.com>
Subject: [Discuss] First steps for ASI (ASI is fast again)
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, peterz@infradead.org, bp@alien8.de, 
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de
Cc: akpm@linux-foundation.org, david@redhat.com, derkling@google.com, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	reijiw@google.com, rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, 
	x86@kernel.org, yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6k6139x48m5f6i75qdfe51c8rojg9ubd
X-Rspam-User: 
X-Rspamd-Queue-Id: 40BD1A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755019871-204808
X-HE-Meta: U2FsdGVkX1991HsrdVXlFdJq3gStL8slpRLMHL7JJ5EKolrOR9cbTBLxVWd1EobHq9L7FeIRn1g8XDtjujaB6nHDMrjORGUXplQHskoYmTA1D4sjQ5MMuLVMq/O1iG7AR1YU9v76JxRzm13O1fODhrbHMl3DA9dcc2BXcUQst8stuSnwi8xBk0QU0DPPxqHxO10PNXYl7TI8eFV3U/nK2NUz2RCxWn77iAMCVOlEiJjofbt5L5VA2C070XyConjIcCuwtm/HFrOnE2nb1Wjt0mwRTtw/lXOV8NYrkdu/3TwZbzK8oNVd9hazGHe/ObQmdlXLw6veSo2x3AIRt+cYWefhUYH2NRnir2ewVs5/MwPaYDpwc42lhIqJYo12NiFPeteNCOuBWx0HuyWd0aFRSxt1vKd6Hg0inCSwmnH3F0e59HRfY4RC3V+uYie0mpb3ivZqMQfdD2pvacN/cluKN7FecU+j/Lgvd3uVqUg6mZH7dzLCVuVdDUb+FTBrmJGCuavpP/9lf7C7NFPXdBR2vv1Y/zgs+1ljg5qQwprIWSUGyXRH3GjLxWr+5+0/PVI4uN6DM6VDnn1zf+x0ny65uOin/Ib4BkhQVmtKAybrG5/powpuCMaoLWfE5CDo4oMS8HJ6qxaWww1+J/rP7advfwado6yXOmWg6WAzTiwY6aNPTsIylemscEkygmQfuFspFp/f9sEsJ3PUv7u3mvDJhSXFJeOJUU1TOvvE+y7y8cx5WcLW43hZebGWOvXZ3rlmSDakJFOz5JTkD4iTnLuubGOsoVacUPGGpzGYgVKExFj+KcKVkPPL1xk/9qt0frQDm3XfA/TfY7hG+CnR0JZBWzGeJ9BJHm/KxwIUZS0hDv4keZaijzqSS0bmO8VH7KUO1L4pKUSbmcdBSzprQch6y3r03ol73b6EuWwgqIdvj49OCnF29pbWSTcNGrBCKPnlUDtbXggP1u+s3Q9AC9u
 Xs+Uko/t
 LdEA6eSNa00aOsooAg2NBTfGmwhROPhmj8Aw2blaibfEjgtiD8Q5deI64HmMwYx+DOcqlKzim8SjLg+ktqxCrSHp19pV3kfUUqwpyVH5CbkuRdgG5/t/ofdPTC2Un1FcIKkXMZAcP5jXXvlFmbtNZgGComrQI9BpAOi1bt+CuEWlmr/h8OSN4WY3dV5t76IlwqI1lm7edpnPQTJayYWe1o852yrljrtId2fEEMQYWwaT9CPepa3eC26zcktYGHd7zf2KCySHqLUftQLmXVsg6RnrXfb1RW17lp9E/5ztwBKT4pqLr0zti/iVk3x/WHmalrdCVW3VAGT0mA7fQJuTYhsJnNmu0r98A+GUfG10YW5N7Ff+583S/eJtSIfdrTVghQ7rzTKoiYMNixZq74gttHix05o6KGzb6Uz5kp3a6Zc3tmFjtsPn/wlFilipoAcoe1OWey7PLgexjc3tUO6DKOdqa13Bm31G5tkEBx+DSVfBWzH8XoeUK8GLwS7ROFv76ZhYfgVERierC9boa4mY4HGzZ3K154RG6jtfsLPzzxnFxfdZFrcWG8Z1PXVTf+tWnFuz6pscl+Z7jUvtIzGkQq9G/tg4cODLZTDv0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

.:: Intro

Following up to the plan I posted at [0], I've now prepared an up-to-date ASI
branch that demonstrates a technique for solving the page cache performance
devastation I described in [1]. The branch is at [5].

The goal of this prototype is to increase confidence that ASI is viable as a
broad solution for CPU vulnerabilities. (If the community still has to develop
and maintain new mitigations for every individual vuln, because ASI only works
for certain use-cases, then ASI isn't super attractive given its complexity
burden).

The biggest gap for establishing that confidence was that Google's deployment
still only uses ASI for KVM workloads, not bare-metal processes. And indeed the
page cache turned out to be a massive issue that Google just hasn't run up
against yet internally.

.:: The "ephmap"

I won't re-hash the details of the problem here (see [1]) but in short: file
pages aren't mapped into the physmap as seen from ASI's restricted address space.
This causes a major overhead when e.g. read()ing files. The solution we've
always envisaged (and which I very hastily tried to describe at LSF/MM/BPF this
year) was to simply stop read() etc from touching the physmap.

This is achieved in this prototype by a mechanism that I've called the "ephmap".
The ephmap is a special region of the kernel address space that is local to the
mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap API can
allocate a subregion of this, and provide pages that get mapped into their
subregion. These subregions are CPU-local. This means that it's cheap to tear
these mappings down, so they can be removed immediately after use (eph =
"ephemeral"), eliminating the need for complex/costly tracking data structures.

(You might notice the ephmap is extremely similar to kmap_local_page() - see the
commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).

The ephmap can then be used for accessing file pages. It's also a generic
mechanism for accessing sensitive data, for example it could be used for
zeroing sensitive pages, or if necessary for copy-on-write of user pages.

.:: State of the branch

The branch contains:

- A rebased version of my "ASI integration for the page allocator" RFC [3]. (Up
  to "mm/page_alloc: Add support for ASI-unmapping pages")
- The rest of ASI's basic functionality (up to "mm: asi: Stop ignoring asi=on
  cmdline flag")
- Some test and observability conveniences (up to "mm: asi: Add a tracepoint for
  ASI page faults")
- A prototype of the new performance improvements (the remainder of the
  branch).

There's a gradient of quality where the earlier patches are closer to "complete"
and the later ones are increasingly messy and hacky. Comments and commit message
describe lots of the hacky elements but the most important things are:

1. The logic to take advantage of the ephmap is stuck directly into mm/shmem.c.
   This is just a shortcut to make its behaviour obvious. Since tmpfs is the
   most extreme case of the read/write slowdown this should give us some idea of
   the performance improvements but it obviously hides a lot of important
   complexity wrt how this would be integrated "for real".

2. The ephmap implementation is extremely stupid. It only works for the simple
   shmem usecase. I don't think this is really important though, whatever we end
   up with needs to be very simple, and it's not even clear that we actually
   want a whole new subsystem anyway. (e.g. maybe it's better to just adapt
   kmap_local_page() itself).

3. For software correctness, the ephmap only needs to be TLB-flushed on the
   local CPU. But for CPU vulnerability mitigation, flushes are needed on other
   CPUs too. I believe these flushes should only be needed very infrequently.
   "Add ephmap TLB flushes for mitigating CPU vulns" is an illustrative idea of
   how these flushes could be implemented, but it's a bit of a simplistic
   implementation. The commit message has some more details.

.:: Performance

This data was gathered using the scripts at [4]. This is running on a Sapphire
Rapids machine, but with setcpuid=retbleed. This introduces an IBPB in
asi_exit(), which dramatically amplifies the performance impact of ASI. We don't
know of any vulns that would necessitate this IBPB, so this is basically a weird
selectively-paranoid configuration of ASI. It doesn't really make sense from a
security perspective. A few years from now (once the security researchers have
had their fun) we'll know what's _really_ needed on this CPU, it's very unlikely
that it turns out to be exactly an IBPB like this, but it's reasonably likely to
be something with a vaguely similar performance overhead.

Native FIO randread IOPS on tmpfs (this is where the 70% perf degradation was):
+---------+---------+-----------+---------+-----------+---------------+
| variant | samples |      mean |     min |       max | delta mean    |
+---------+---------+-----------+---------+-----------+---------------+
| asi-off |      10 | 1,003,102 | 981,813 | 1,036,142 |               |
| asi-on  |      10 |   871,928 | 848,362 |   885,622 | -13.1%        |
+---------+---------+-----------+---------+-----------+---------------+

Native kernel compilation time:
+---------+---------+--------+--------+--------+-------------+
| variant | samples |   mean |    min |    max | delta mean  |
+---------+---------+--------+--------+--------+-------------+
| asi-off |       3 | 34.84s | 34.42s | 35.31s |             |
| asi-on  |       3 | 37.50s | 37.39s | 37.58s | 7.6%        |
+---------+---------+--------+--------+--------+-------------+

Kernel compilation in a guest VM:
+---------+---------+--------+--------+--------+-------------+
| variant | samples |   mean |    min |    max | delta mean  |
+---------+---------+--------+--------+--------+-------------+
| asi-off |       3 | 52.73s | 52.41s | 53.15s |             |
| asi-on  |       3 | 55.80s | 55.51s | 56.06s | 5.8%        |
+---------+---------+--------+--------+--------+-------------+

Despite my title these numbers are kinda disappointing to be honest, it's not
where I wanted to be by now, but it's still an order-of-magnitude better than
where we were for native FIO a few months ago. I believe almost all of this
remaining slowdown is due to unnecessary ASI exits, the key areas being:

- On every context_switch(). Google's internal implementation has fixed this (we
  only really need it when switching mms).

- Whenever zeroing sensitive pages from the allocator. This could potentially be
  solved with the ephmap but requires a bit of care to avoid opening CPU attack
  windows.

- In copy-on-write for user pages. The ephmap could also help here but the
  current implementation doesn't support it (it only allows one allocation at a
  time per context).

.:: Next steps

Here's where I'd like to go next:

1. Discuss here and get feedback from x86 folks. Dave H said we need "line of
   sight" to a version of ASI that's viable for sandboxing native workloads. I
   don't consider a 13% slowdown "viable" as-is, but I do think this shows we're
   out of the "but what about the page cache" black hole. It seems provably
   solvable now.

2. Once we have some x86 maintainers saying "yep, it looks like this can work
   and it's something we want", I can start turning my page_alloc RFC [3] into a
   proper patchset (or maybe multiple if I can find a way to break things down
   further).

Note what I'm NOT proposing is to carry on working on this branch until ASI is
as fast as I am claiming it eventually will be. I would like to avoid doing that
since I believe the biggest unknowns on that path are now solved, and it would
be more useful to start getting down to nuts and bolts, i.e. reviewing real,
PATCH-quality code and merging precursor stuff. I think this will lead to more
useful discussions about the overall design, since so far all my postings have
been so long and rarefied that it's been hard to really get a good conversation
going.

.:: Conclusion

So, x86 folks: Does this feel like "line of sight" to you? If not, what would
that look like, what experiments should I run?

---

[0] https://lore.kernel.org/lkml/DAJ0LUX8F2IW.Q95PTFBNMFOI@google.com/
[1] https://lore.kernel.org/linux-mm/20250129144320.2675822-1-jackmanb@google.com/
[2] https://lore.kernel.org/linux-mm/20190612170834.14855-1-mhillenb@amazon.de/
[3] https://lore.kernel.org/lkml/20250313-asi-page-alloc-v1-0-04972e046cea@google.com/
[4] https://github.com/bjackman/nixos-flake/commit/be42ba326f8a0854deb1d37143b5c70bf301c9db
[5] https://github.com/bjackman/linux/tree/asi/6.16

