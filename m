Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7B160A2612
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJ2OE9dQ
Received: by kanga.kvack.org (Postfix)
	id 3E6816B062C; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD236B062D; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25ED96B062E; Tue, 27 Oct 2026 04:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E85736B062C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:46:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8828A1A090A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:19 +0000 (UTC)
X-FDA: 85367774478.27.DFB1D21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6BF1380003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJ2OE9dQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf30.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090777;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=st5nDVWD8wUV9IfzpB0mjqzSu3cPMKWpcanbJcCL4bg=;
	b=6nk+ixlmlHgLZuiPe59dlSM3U6AZujvCH3J8FiZlbKAVLeZ4NKCgK03HpuvzlXKDu8jcsf
	MuD9S07hs7v7CQRwzkyM7VqNU1CmuiSFil7b0ODLZA6Nw2fD/o2H6IIFLb4rQwZWiWwYfW
	ZJB52yHTSQXNFKweYGt09hjmhcl/4+I=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJ2OE9dQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf30.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793090777;
	b=OgnkUuDsRB+bpimCsmfOD721CU/3NG1ov2E+YS2wNfow0V8cn6S3VLweb6fpEw2hue+kZO
	+0VYJ3EVpF1THsWHeU0FK/YV6XnCPJFDW1oaTPbJe3M0Hwt5L1njWoMECogXHlzEdc1ivC
	9mev/31N6Jq48eaMeTee+AgJJPSLj9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AABA640409;
	Tue, 27 Oct 2026 08:46:16 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793090776;
	b=aL0Ih/4pfZInMelSo/BlqV0acJm9mX/pluGsTPTwHiu9urqba24uyk7hXFbKggf9EvoP
	 5AK5WGk3IKl+GCD1JwPcE2c5IydKMAyIaoovDD7iEST5eMi+WQWVkA1WWnK0C9uTCw8eU
	 aRdAyOTg61yEGQ8c3Hus2wOtGBWroLR3QD+zpimaGo4IkkeTS5bwfPwGU8vBw5CeEzhWA
	 dN6hW/lw19VRXf1h4DaxILX7faBVKZ+hLGfe86/AJ32PHwrfnMqEI72f8CFWJ70YD43Rj
	 MTWYEgn7znXck4Kz2mTLerflB7ozpWmWLmvsViP0RmqEjoWxW6RtoRHEOiVCaOVcIKg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793090776;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=st5nDVWD8wUV9IfzpB0mjqzSu3cPMKWpcanbJcCL4bg=;
	b=jek5pYdTD1gc2nreXy7D0oD/17rpzLphOsnonayck8QdJXxfeVgKkdm8nvzSdKmnY1rv
	 6psjB12tDQwYBs3/+sdHol5mN2aXD9+DB6Nm+ltQ0KBn4ZdOSXLeoUszYmunuzBpxDkjA
	 5xYQooklMxKv11kLvXfvbKuhN0wKsc5iw261eGu/B4EV5sS+EZnvSGqCf1LsntHoBv8Xx
	 wq0pzi4xnmuHu9kD1oRDq7Z8jXP7SIqRKk1oHcu1cUp6M5E7LTG4GalYxSYuh5ofHSIA+
	 B8ZL/mYHwcJPoGuUb5gnFhtt02KRtgYVsZAoau3nVZFZMTRWmxGguQBHmme3xibK3wg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BF1201F01828;
	Tue, 27 Oct 2026 08:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090776;
	bh=st5nDVWD8wUV9IfzpB0mjqzSu3cPMKWpcanbJcCL4bg=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=CJ2OE9dQkedPfXCslp8dw1/ESmpPDJyUTq2J7ZAiq3RJtsgOLmkCzg0qTuMdQxv5P
	 +4QDqR3Pe5qV6Bt8aGyUHFXrhAeFlOye+vJ6BRwjMMFEz/JDTpnde/ronOnuBv76y7
	 Mj3lbWnKLAEJCOY2o7aEKTIdymog2KX3sdY9GR+onxXhuftVDB+KZuR72AkCpm/aw7
	 fzC53J5UaKcBPvX1BM4RFJkHrl4xb5iOcqFU3V3DUm3JWIE14O5rqnihXkLAtYEJWk
	 E/TVzAq1sBnePLBys/UkuDs/Eaf0Z5PCNMN7iV671cnf80W57mbpOflI4bNsjoYIYy
	 xyaFURltg8LkQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 36F5E4504D;
	Tue, 27 Oct 2026 08:46:15 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Subject: [PATCH v4 0/3] pidfd: add task path ioctls
Date: Tue, 27 Oct 2026 16:46:06 +0800
Message-Id: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22Qy26DMBBFfwV5XVd+8Vz1P6osxuMhuGmAYge1i
 vj3GoiiqsnySjPnPq4s0OQpsCa7solmH/zQJ2FeMoYd9Efi3iXNlFCFqGTNR+9ax48U+QixCzy
 vCyNchU4SsfQ1TtT67434fth1uNgPwrhi1ovOhzhMP5vlLNe7G12JB/osueCAmoiMENrlb/YT8
 MQdhdMr9mx1mNUfhpaPDJUYmNcEBShpS/WMoe8MKeSTHDoxWmVyY4RVVov/jGWvOtHXJW0Y9/7
 MQiCOw/nsY5M5qXOwJtdQpi6gTa2FdQ4ktcY6rABbwEpsK963b7I9kypvmSKEU1oEKQRuy7okt
 Kk3mCZNeViWX+e7sBbRAQAA
X-Change-ID: 20260819-pidfd-get-paths-59640d8cd1ee
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5058; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=7K5N7zpkceKer48CAY5KA1GcflvVMOjT02wequ/ZwwI=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq4GTRzWFjBBYAkSoCfyF35AnP2cJOwvLQDzp8U
 +FdmKrC1qaJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCauBk0QAKCRB2HuYUOZmu
 i6eMD/wIVN7mWr/rDzRl5O+QhfFzRIu+DC5RKcqCwGYOYKRt4RGz6JA4tr1o1zT+zz9A1sZws1h
 9b4YrzUGpT/3BtQOjfMF55pk5nbOX/5yzi84hAKSvav8bDzx060JGv5aebg6oQdNKoWfgVAvbnw
 V0BUaVIh/n2a0FJ5yA+0JxhzV8VnnYMT1lpNAecXFYtsdchX9N0awErBeoRO11SYyc8QPK9WLOo
 VbwOkbuXV+JsXntvqNo8fG6lmgQK/B7WRFLB1wm9MBn7+vcQq0h3Wv394taZkfmVU0TS/tLTiSd
 HRr7D4EYJQzBwZW+a77Ox98emfT79T1oI1izhm1lfaUWBmTd+hwjmObBNYKLyPDRC++0t6mAgLC
 R8sXkEEsJTI9N5I6/MJgL30dkvhr24qAKHtlT27fa2pe8oLRRGxhMox5VWPS/V9dpG1f/mHHE0e
 cGXD6rCMJJE+TUe6VIsYIHntIJpUDNhpWyL4PZqB2SSJuk/6aob1nZC5EMNE2cYR3KIdl3yPbTX
 uLMcRAzh7ECWZyVoCiJpONNHL3cCbSZ+CbaeU6V01xlu07yP1En/LpVIMST91ly3DqN4vNzOdFZ
 UoLDJZ2tFGHHiqA68/QJ8PiShql662WFt9gtu+UrNtnAwzIEic+mtKlNtDdnDUnHrkrncT24SGT
 wB+p0vvoHzqPRBQ==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BF1380003
X-Stat-Signature: idzo9sb1g9ay5duruyz8pqzfoqzqxq18
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793090777-272159
X-HE-Meta: U2FsdGVkX1+cFjWmaFRMPbOI+f4Qe8g124gJu7O8wnyntkRlStXHkSX5cvpd1+CY7diJ/GR1SMe6QOzsJB0DG5gMfXwCPQo4wWXZkzXkr7m97J63OBsYVhP8uvAc7w0wXHB8JzqX+3LiRk1Hwdzc5e71iR6wYHhuinHtdsj79u6h/xKUJpWBUh8VXqD4Rtwzip52asV8baPmQjEmUanpbSJY6MgYukWp3uCsZ6mBvhYVqzWLRbKxzOOrofNxRPYGF1/VUlXU9clTzdnaojhLQZOqbFTQnVM4ywqY/BLqp75hWB54mDpmjfUfKYZgZLxQ/6pobLiDgIfH+WHewAKPkcunSucCzACd8u78UV2KH7DYkfjag4alQQNVQXnXclGmuTZgvEBQEM2IPW2T5REXACvObunDNWJDPh/CYrpUfHdz1uheJKoiD16BrvbAJ+mX+XRK4UgaZdF2THaZRB3WhGMCQDfWDj1zORNsI1XMAaYcMFTVH1Hj7ayYYrRC8RKIxr2x1rdksNZRNnmxgQTg0wHpPwaXru/seQ/7sQmwwWqhhy+6OYoXvQmtAzZ/NJef90lndLh3R/04AdZgrNqY/yYQe46k9raPoTCtqEkeAWqAeQ1xpw3Ydl9UosIzdWBl3r/DjKGZu4qtsPl9b5bjSljhqzbJdKwoMPVSCZJxwJAb/76+7OMTD/KMnwb5l9O2S8PV0Ou2+lbOeKcNM7QZWPPT8dhPqwcPgApLr9Xygs178NBqU8tYB56ViPcjXA7OGjrrfBO2i2aaxQ9qNfShLqPoH51PUZWtQzXZKnESpmbF5N6J2lurTOLwWs6YXrMGQSQCB//amHU4sW6Pa1yYjKm5qQZVmiL6ygB7fnvYVFxGhK4enjBoQKgtrZZZn+JRC5rnCIRqO//yt7dWQeHN6G6hB+4cs8NVRFUEPt/KNF60s/z2YdUVrG8tUhCF88YM1FzIr8me66TyKJ+i7YY
 6Yl6vsU3
 8b+CzOrzVVQFLJJXRQ8Ed0Vy8HXt5nFiGty1BzlGltS/UJvr2X/bct/b2oFPT267BtVW2fVaI3NDMl3s0XqRxvjYss3mm/QZpAdY9lVByVRj9nVXpgR7KGolANFBTatd80QjOFnBSpAqjlWl4NeXWLzWTKn27s9kdGMt9LhqzzTKo44wr77e4RBRp9j/b2WonreMl/aDkET9N7H7xH73/nQKbrbRbcOkil6u2kmGb002xmvCUIqM4Nwgg63ruPLVAkQEEjn3Cobk+tilrGsLyObCRZ5htrDbnko+v0x42lDUDeVgRumx8ArbqbqoNwWh6r+26N03WNfvt2KLt7rDId/DfRXb7Xv19MINb1ZJPfugiAK0ukm6g3ZC1Wb3N7o3eAFcOmA323uNL5vodaEGOe98yiWPNhs2HzkvzBmJXtzkhKU/ozV0b/1bFmxktYWqZJVfqK3vZTRx2pWEdY/Gh8INyeGEyBqfaUCdo0HNEUcY1uv7rMp7IGqHBdWo+UirKQWRKELqtT0o5yI9A6LXJvKlXTPmNvnRdMi3UkcPDBZ7imYia0FvGttAOfyfQfOhIP4J9NPidQkYLui2505bQu0VV6a5XELIf7LW01KwKtOd5tO7bk+wpuwAF5D2GKc6JuoOqrcdI4CPCccLdXz1U+zmIvCKdcaiJ1UYFvMX0uawLGTYQGW/G0ynad6PWLdKJZN99L9hiNGezhPXGcrPxoH8FJPgbMFDbhq9l/406POvbDDOuN7K83jkd+3LsVT5CuqauCpV0lsCnFpl5xay23ff/TNS6GpOioa5g56HC0yS4lVA3oaN0MRBg234741AlMWnZqyepSZO3ewCNsU8qF5khl6AXQx3tO7KvREg8c988Lk37eSnQXOjiNpkB1/AlYJt/jqgHqZAexstfv5OK4PSdz6SW4BzxMvGBr5rtg7e1C83QIDxA79U+1wBlef7407szR6DoRPpOVK3zl6E4VdL4OYRn
 Tor3B6Ir
 B2S0L2JsGcqwU+qQ2mU8U3fnVPkugeGZ0UQObXhwsnmUPFOEBeMtgRT1JIXqLJuoccpIIHRq79XjjK0XNA7b7PmUvl/hLEUrTLE9rYbmPSph69iXRrK8TCQ/fuGpF3UZYOrHVIfi/qeEg41Gl+rOBxlt7orEw3gxm7o2b2doU33+rVeXC8AFLlEZZU76W97rXZ9CVgW/entdEC0p4Y6u32BrDtgb1ggicXHb1udF3A+fKLWpxPX77pDNuDJ6G0/JFPT7dyxm0UHlotDVvxOFA2pNLX7P0iKbToFv/ua5K0drJM04XCTFIxKDLcnKyBdu4Iu6T4vcK05Hn+NnDG+BgmXhXBrPfeqRJwW6wNhMrh1YzIx2Cb/ikfyGrANOMJzo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Obtaining a target task's executable, working directory, or root
currently requires walking procfs symlinks such as /proc/<pid>/exe,
/proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
on procfs being mounted and visible to the caller, even when it already
holds a pidfd for the target.

This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
ioctl takes no argument and returns a close-on-exec O_PATH file
descriptor referencing the corresponding task path.  The new ioctls use
the same ptrace permission check and nonzero-argument rejection as the
existing pidfd namespace ioctls.

The target task is sampled while holding its exec_update_lock. This
keeps the access decision and the task-state read in the same exec
critical section, preventing a concurrent execve() from changing the
credentials or target state between the check and the use.

The first patch factors out helpers for acquiring referenced task paths
and reuses them in procfs and AppArmor. The second patch introduces
scoped cleanup for privileged pidfd task access and separates namespace
lookup from namespace fd creation. The final patch uses these pieces to
implement the three new ioctls.

This series depends on the separately submitted patch:
  pidfd: restrict task access ioctls to the caller's pid namespace
  https://lore.kernel.org/all/20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn/

That patch was patch 1/4 in v3. It restricts the existing namespace
ioctls to targets visible in the caller's active pid namespace, following
feedback from Jann Horn and Christian Brauner. Apply it on the base
commit recorded below before applying this series.

---
Changes in v4:
- Submit the pid namespace visibility restriction separately and make
  this three-patch series depend on that submission.
- Rebase onto the prerequisite patch on current mainline; no changes
  to the implementation of the three remaining patches.
- Remove Assisted-by trailers following the updated contribution
  guidelines and describe tool assistance in this cover letter.
- Link to v3: https://patch.msgid.link/20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn

Changes in v3:
- Restrict the pidfd task access ioctls to targets visible in the
  caller's pid namespace, failing with -EREMOTE consistent with
  PIDFD_GET_INFO, following review feedback from Jann Horn and
  Christian Brauner.
- Document that get_task_exe_path() leaves the output path unchanged
  on failure, as suggested by Jann Horn.
- Link to v2: https://patch.msgid.link/20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn

Changes in v2:
- Make pidfd_get_task_locked() own the task reference until it is
  transferred to the pidfd_task_locked cleanup class.
- Link to v1: https://patch.msgid.link/20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn

To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Kees Cook <kees@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
To: John Johansen <john.johansen@canonical.com>
To: Georgia Garcia <georgia.garcia@canonical.com>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org

---
Chen Linxuan (3):
      fs: Introduce task path helpers
      pidfd: Use scoped cleanup for task access
      pidfd: Add task path ioctls

 fs/fs_struct.c             |  44 +++++++++++++
 fs/pidfs.c                 | 158 ++++++++++++++++++++++++++++++++-------------
 fs/proc/base.c             |  34 +---------
 include/linux/fs_struct.h  |   3 +
 include/linux/mm.h         |   1 +
 include/uapi/linux/pidfd.h |   7 ++
 kernel/fork.c              |  22 +++++++
 security/apparmor/task.c   |  12 +---
 8 files changed, 194 insertions(+), 87 deletions(-)
---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20260819-pidfd-get-paths-59640d8cd1ee
prerequisite-change-id: 20261027-pidfd-task-access-b797ecb260a4:v1
prerequisite-patch-id: 021f6b0840ced7fe967a849b99c366257160c005

Best regards,
--  
Chen Linxuan <me@black-desk.cn>



