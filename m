Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E860C87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 05:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50DFE6B007B; Sun, 27 Jul 2025 01:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF876B0088; Sun, 27 Jul 2025 01:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD376B0089; Sun, 27 Jul 2025 01:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26A726B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 01:28:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2C7316095D
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 05:28:42 +0000 (UTC)
X-FDA: 83708914884.26.04F5ED3
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3391EC0002
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 05:28:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ur+tlaQ;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753594121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y4fzyMbg9b9tChn/1fYJ7NRuUNWKz/X0SkndoLYJL0g=;
	b=qt/T3VBipmtxv1WygCzfcUQwcUiJiMJ+sodb8tNemvxBYeAlrWGwv7NYtS3ZBdv9E2hV+E
	hjeYbVmrayZIypeUfPJJ+J3DQYqWOLls1Ql0Ot4rMw9YrfZbnrz6Qi6e2HSWUs5GkjA1Sh
	8PHQ62lGDixog7yivLfmm9C9xwBMkwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753594121; a=rsa-sha256;
	cv=none;
	b=alDJ6zU6ZfLMMOjYv4BJrSNAjV4JkJI26qX6WA3DErxBRVv/FQ3SXiLQaVOpxlBcZo95f+
	N19quGqiNsngIIDp5XImVfkMiWfUhAGN9RL3GzgAFbkOuOMnxgbxEfddEaOZOc9mQ9ANQM
	Mg1PnQXQIAbYJPNpgU7NqSghpk+ebDE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ur+tlaQ;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2357c61cda7so110285ad.1
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 22:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753594120; x=1754198920; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y4fzyMbg9b9tChn/1fYJ7NRuUNWKz/X0SkndoLYJL0g=;
        b=1ur+tlaQ4i1zPvmsFCTUTNBahEr3S9QVyjqNuKmnBc2KK6rXjgGG+csJIqpCLeGAC3
         qZ5SCswxYEb6cieS3V8bvbRT8fUSWHTxFokqZjg/lWqRtmMoGtbyw17nbr9VE3mPymu5
         WMwuIWh+ai6OHMVlTXYAZeLNM0NPGOYhqeZUCLVYKNWk6bLGAP5pnPkrzM9G28u9oEEh
         7Q7FPC3kaAmivOJujDyzvuEUs2PI8kCsURudQ3ArIvrWtVVuKJku0F71NC80a2nQueoQ
         +a8f3Ka3jJjsCW9kuakPqCm2KDTToK9Krx/TUEM2QyaAOAwtinLBnhPnuleSnseKwjkG
         9jig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753594120; x=1754198920;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y4fzyMbg9b9tChn/1fYJ7NRuUNWKz/X0SkndoLYJL0g=;
        b=ESBsFkTYOL4CPv2dg+yLb+EkHcwcbxTTM0IpDRGq7mhJBQvbloQvZZozUZf1YL0wf4
         frLfCp5yg9uqstuqKzIJWRA7EjpE4c1j1BjAyN9UMNEkS26TjP1qqXSSg29KvFgC8jCL
         ug8++rGuXHOCdBgXb7qcV1SrNmi0uBHvR/IQ+mW+WCIXKv9kBb2cLOSqmRwKG3P0gHvx
         lNshrTJE21IUOydCJqBRHupV5xHXrbnYYH5uP7MxTDJCWyZrH+ubJEQLDlD8T9BqSbf5
         6LwPGN0k2Ku+jRcyrAj7YCl4k+2A3xO2HMkrZWJdKWAyhmyt0YF/rWykr2w1gapSpql1
         SmnA==
X-Gm-Message-State: AOJu0YzcPyzmYiXKcHOTV2sX2QFMb+TpJbvnRu2y2kob7897bUo1N9UO
	nR+GPUZD+AICkfQ48HkJMIC4+8ozkH8glWU7EyMLvKpst8mUsDE0Tfoi5y+RPk1LYw==
X-Gm-Gg: ASbGnctCjZ7w5HSwEM95mH3R3ie2jnFiafpUCmtbhEKaf00OwhcLj3w8ZzjxI2xTWIQ
	LxIT4CHQw57bK85hHym3y9y1Gl429NzB2rGMUs/SWfdWHf2KzU3Qhg8MHvo7lflwYaIGrjk2Rhh
	vkf986hNrWrZXpm+2iD0MEJY1vyDCze3+iO7/5RGGEG7WVlDRI8i37Pcwoebrv3rHggYR4kOUic
	RyEwDcHoqHcGfYlsBLfz5Pduq6NhQW+wWiMIy4iRq12WQulkdO/wuML7dGP0d8nuk/rKKXL9NXF
	isVb/ghwPePobuQPHn2/wtQiiThznXlZhydhHj7WMcdgbqq8KJxeZBofM/PcOTo1jmpav/C6tKE
	XiFJ+0Uz0R7lPitzzSQczJ6RRL+gy4b+aVz4BU7kPPuA0vyxAYsrKjpntsxmQTE9MA9HmxZFzRi
	hMzHpRFyuMz0y0Q7Pm+lkqW2oa85M9jWetBpy/XA==
X-Google-Smtp-Source: AGHT+IHnc6cUG06f6cNWo4opD7IJz7IhkPswhlCALVJIFBdHGdAJXNrJvZAaR9NFudPqT1pwJuP30g==
X-Received: by 2002:a17:903:2441:b0:23f:f6f4:246 with SMTP id d9443c01a7336-23ff6f40326mr596465ad.19.1753594119390;
        Sat, 26 Jul 2025 22:28:39 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:364f:4373:b756:1458] ([2a00:79e0:2eb0:8:364f:4373:b756:1458])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7640b1e0318sm2827904b3a.93.2025.07.26.22.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jul 2025 22:28:38 -0700 (PDT)
Date: Sat, 26 Jul 2025 22:28:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
    David Matlack <dmatlack@google.com>, 
    Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Jork Loeser <jork.loeser@microsoft.com>, 
    Junaid Shahid <junaids@google.com>, Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from July 14, 2025
Message-ID: <ff87b623-2e8f-2fd8-3db0-d592804e1466@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3391EC0002
X-Stat-Signature: dfmannjoaiw3zwo84e8fdagafh46udg9
X-Rspam-User: 
X-HE-Tag: 1753594121-617084
X-HE-Meta: U2FsdGVkX19VQBW13xwvFz8qYlm21O2hQrzXEJ+bVJRgAt3taA1O4fehFtE2MRVTqoIuvNqorh/+LVk+1K7/omD+CornloqxX3bFnUJmIO16CManu9Ggb57wQ4oX6BqdL10yKVluBf4Dskpcp+NqoMK6rW8lJDoMxbVWfxGtbn8dOVBrATrKQ4ligRpRFk5Zmhe+VdV1AtW1I5zACarNDDG+atuT5Y+5jvJK0J4rjCdWWeWWiX0n+Q7Q+Ocpl0Iwaqmk2YdqMJh8KRArNGgDKT/Q9aghWRqiTFI1B29ulZBmD5WRopRgCGIgNOd+vcN0ycYDYrvP6FwXsP8BjjiZ18UTIieCS7mcG2LJmxt/kVZoyGrKR2DV8maf6RJRlS9blZJPzgyOnecWPex9w9e7uXaWdTTEr8917Hse4wlx/4UTpFPh6bXbTxZY6EP6P7dEJ58gBy4L11SB4HEqjeKqKVkJKTkUX/gEB8NiESqbmLs6xNO7ACvQZTSwcW4SmGEl1pHv0tua8aWPhA7cFcYbtI7o3vUFcEiOx4he/rrJBAx5u1gTeGivOPDnDtNjDrqkE9t5Ltd0b56QD0tKGzEe5ObaWEMXGYJbYNZJsfU/2nb00Pa29p2IdxdOh7Ugpk8Ixo98/BEjQSrE47OrbaIuCaWqhBoSr7i+w1jC3hQRsaCVyvdKbr5Kz5VmhzZEUzc3/UaEAT5p+3gWKYYi2d7zcs41dz8ESYJXjIKIz0/0c1/tTn2hETIVWts5Gng3FA2j7mcquqRJRgRz47vcdr+6cRMFDeBJEzcLBmARIcA7eWdLeq5K4LU9G9win4N9S0WNZj+fhgx0CNtOsRBU9HhoMPFykHiPJnlsnCuixKByK4nipeekBoIIft7n6/lDFU62U42O2TQ2jgBgzYkSxL++weOmm4RjDeGPT/WqbB4r3YZsjXEI2zpFiUuRKUz9re/hTmVzDWuS/xqxZP3Ce4z
 3TWks8aU
 cm6bZivX0fyTWzl/v315scGo7Vih3bycGat0Y8gsKNlD8fYB0L1NjH1nBG40B5B9qpR6zEXP8B5VWEW8cdMQ9i5tlXZ8LnrSJyj5Nxvr5pwMxoa4pOkZl4X736Zbj74L1j8oMwxtMNHHI3ho2mn4WjoeR7PDAyL/dJBCC+aPEaoIkh5s+LVzLN0PJQ3rBKJMYkmDJgrLs2vVlMYCZCbLdR4ctPKk4CU8gufZ4w+XJ0mHMVNG11zy8FctlkUWbq4X1yOTkHBjcptI27+NoVzPwsHIvDyYabmpvJyFsZshpuWrn972NJO2ssgNVhrEufa/DciwnvV9E8wJJNds2z3DDkmqNtXDud++R+zGqBtMLCtWcrqmqnifWWWizVHDZsxBulBLvCZUbLgPtMbzNdsYVX3uXnQdVto6nkMMJK1EoHyoIIJwjQwoPFjD57EIbqi0TjbkKLz66s7JJJqDOzcwqekbIy+44qBZOsX8Dr2ir9JiJrlVjB7Xx5wsv3FBeEwWo93IO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, July 14.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Mike Rapoport discussed a proposal about sticky preservation with KHO.  A
colleague had been working on integration with Microsoft Hyper-V (MSHV).
They want to mark memory that is persistent forever so it is not necessary
to mark pages as persistent for every kexec; this would continue until
there was a request to stop persisting that memory.  An example is memfd
to back guest memory where the layout of memory doesn't change much;
another example might be PCI configuration.  This may be used for memory
that is obtained from the HV but then not tracked anymore anywhere.

Pasha Tatashin suggested that this would be another user for KHO and not
part of LUO.  Mike suggested there may be states involved with this memory
since you could eventually mark it as not sticky anymore.  Until this is
marked as no longer sticky, it would be a permanently included fd.

Jason Gunthorpe asked what we would get back on the other side of the
kexec.  Pratyush Yadav noted that we can't change the size of this memory
without more effort.  Jason suggested that MSHV would just use a KHO
provider and preserve with LUO as normal because you need to track the
memory.  We might schedule additional time to discuss this in a follow-up
when joined by MSHV developers.

----->o-----
We discussed current status of LUO.  Pasha at the time had sent out v1 of
of the patch series (non RFC) and received some comments.  Current version
should address any concerns from the RFC version and also includes memfd
preservation from Pratyush.  There is an on-going discussion about using
kexec fs instead of using tokens.  Jason suggested against using
filesystems if at all possible.  Pasha noted this could be a future
extension and does not need to be part of the core LUO.

Mike noted there were two opinions being expressed: ioctls shouldn't be
used and how much dev tmpfs differs from kernel filesystems.  Jason noted
this is just a regular character device like hudnreds of other devices in
the kernel.

Pratyush brought up the previous conversation about handing out sessions
so when serialization is done it is done per session.  The agent decides
who gets access to these sessions.  David Matlack asked if the agent could
hand out sessions to unprivileged processes and, if so, this would address
concerns about all saved fds being sent to the agent and context stored in
the agent's process before being sent out again.  There was general
agreement on session fds; an open question remained about whether the fd
passing would be done with sockets or bind mounts.

An example Jason provided would be to create a session through a file in
a filesystem and then give that to qemu; qemu would then open it and do an
ioctl on it and provide the kvmfd.  Pasha believed that it was very clean
to do the policy through a userspace agent rather than in the kernel.

----->o-----
We transitioned to discussing the agent, liveupdated, which the group
thought was going to be needed.  There was a desire to have both Christian
and systemd people join the call, so I took the AI to reach out and see
if they would be available.  I asked about where liveupdated would live,
if this is something that would be shipped along with the kernel itself or
whether this would be perhaps its own open source entity.

Pratyush experimented with fdstore and was looking into whether a process
could survive through the reboot call, or at least an fd survive through
that call in systemd.  Pasha suggested there should be a way for the agent
to survive until the reboot call if you modify the target to not kill the
agent process.  He also suggested that while it may be attractive to have
this as part of the systemd tree, it would be separated from that
entirely.

----->o-----
Chris Li gave a quick update on PCI preservation.  He said the current
support allows for the PCI device to preserve its state across the kexec
and allows for supporting DMA during reboot.  He suggested the inital
patch series to modify the PCI interfaces to allow registration will be
straightforward.  However, feedback and discussion will be needed for
changing PCI initialization for device that already have state; these
changes could be invasive.

----->o-----
David Matlack shared that the live update microconference was accepted for
LPC!  It now shows up for the CFP so people can submit talks for this[1].

----->o-----
Next meeting will be on Monday, July 28 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - follow-up on sticky preservations with KHO, any additional insight
   provided for MSHV use cases
 - discuss any on-going pushback against character devices and suggestions
   for using a filesystem instead of ioctls
 - status update on the liveupdated agent, design, and timelines, as well
   as open sourcing it and libluo in its own repository
 - Frank van der Linden: physical pool allocator, used to provide memory
   for hugetlb, guest_memfd, etc
 - Chris Li: update on PCI preservation, registration, and initialization,
   and the RFC patch series discussed in last meeting
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://lpc.events/event/19/contributions/2004/

