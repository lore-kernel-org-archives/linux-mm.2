Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A46C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50FA36B009B; Tue, 15 Sep 2026 05:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C03B6B009D; Tue, 15 Sep 2026 05:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7B06B009E; Tue, 15 Sep 2026 05:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE8F6B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:08:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 917131A036C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:08:09 +0000 (UTC)
X-FDA: 85215419898.24.2502F89
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id D40D7A0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:08:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RrlB80E6;
	spf=pass (imf15.hostedemail.com: domain of kuocyclinder@gmail.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=kuocyclinder@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789463287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
	b=jSY+aV9SaUF49LlXbeQjBXPLYzI7GYpfpGX4TwGnTCgbcLrqAfXjTj/98KlYsdK8FnmI1g
	oC0lTTKc/y9OiUUt7J9UpP2EBDB+jTsseyoIcVu35z0vz6wdoQ1wcha0lHIpgYW4r89hOw
	a431kGZeDDwpUEqdK7Bcb43QpxNpGHA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789463287;
	b=HDGvQblypPjVih/l6A3A+ABwHIT3puFGj4IJEma5p0EAz7FErJcOWkQvsgDPY4lJr1WKIO
	Ubha1W88MLy9ULCCO2RoY8Tc/cDnuetgdoNp0u423PBbnvalyM4nR9yJPYd2FwMedlextE
	E9I6DFra0GT5TM+ZJatFdZ4loel5nn4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RrlB80E6;
	spf=pass (imf15.hostedemail.com: domain of kuocyclinder@gmail.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=kuocyclinder@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab201f9so2589107d50.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789463287; cv=none;
        d=google.com; s=arc-20260327;
        b=bDxsJ9wyUosUfVLn45Qdt8PCQTKHzKgahznhVbZVjk9VK5uyRdm0nzpU7UaUwLDUoA
         6TnGr4t1guKigb6J/S5yG21I0nZyRPyH+0yQ+DlYvUSabEwilVZMARpSjG6qKAs/ZvSg
         DLn2NZJeyeyL017o7Efp0tbrqLooXFltoqFU5+cpMrRsqLnr4aGUs2PRB8I3VrU/oRSV
         lhya9tV4yEP0KZyZFDkoDzO3loOoL21hW0GKpjxk0Suv47CZaVme73Vl2BFU1Un3RGlj
         Q+AncZXEO+3vkKY1+IECtcFy5Tbfu5qobN1rYxuTZWtJwrRr+KWESp5i5LMs0xgkweif
         s5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
        fh=GKJ6JCd4i2svkIYptaocrjxsZvydyGlQWPwlcJTz8Ww=;
        b=GhtfxBSlgNw6aobnK0BQ/XXErCNLitUbGsVrdtaED1PlIhfYGciW0JAmz0KRLMFhCY
         10UhgkB3HY+e3DpCjLhTBAe+SFuHaLpA1C2Koc3zh4bdctNH6cYQAdddnLrNESfVoJvh
         KoG7g10oOlmBLIe8++vMU/biDzAjpwrrcbX5/owYk0oDq6K79m6wyHP/6nv/aQik/KsM
         MaE1BdedBL24ydzfEW6j32DqoNUp7hAquca7xqzKNCXXO6xyHpjBM5DleSXChGw4NHoj
         4OJDy+z6xS0N36BOVJTMmI9+a9i768RRAwHsPDbthOmvSI7wxbWbSkykTbUGQWCLUd03
         c+eQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789463287; x=1790068087; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
        b=RrlB80E6VaXWjncbO4y+3X3WL7yIIwkyygy3LW+44uxSl7iIfViQgTkbhu3ZUHTVEz
         zaLOTRbNJdhS4068/kw0CKedZwCAyY1QkgDWU4oUROemaC0Io46irSPRJ0YpJ4xBMbOQ
         OUSS/o6dCGf//moEuVxWWFcukEXMOLS5Gga8G/+ksBTCKJ7BLmcjf0yZc3h43tE6yCs3
         lIfkw0YW6dc4qO0mV3EtD5f5rfWPryGsSu9PflvpJH0LU5xwXVyimzFto1xmVVGN3Ma4
         0G+OdYkUnC8l9WTernsvdL+Sk7AzY/XtrXnBRh/zKHkblIVc9v+rv8jCXVBt+29Yokuj
         kbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789463287; x=1790068087;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Gu8o41I2XXzRYGs0+w6OrfrzhP1q+smJSphMsWAZ4Fg=;
        b=MLopL99K9ke7uwMgw2LOmsrtqpFv94/mRtoR2cFrDydKr01TBb325XSxfYwGnnP0ML
         b7mZcySKry09E4KH7cjWUyr38dP85GScPqTHUZzFPqy/xuZt35XQDEcvN5jaoH5cVmnj
         cai67lY7QjY+haChqHp6KYM1Fq5odEUjMh/BK370Uy6smQc8SqV1I7s5hpDLRS5ofmFf
         lxJQ88g+Z5I7ZT3wedO9C1cj5r+kMD79c8g7pFW1IzcmeUTVZiyfgq/vcovCsVI97jlh
         p90XW+n8d/NezKqEOtQfS2DNf2/58D+XJ05WwzI8cQzXXpbavuSsJuAre0VkPeGnx2Bj
         jxOg==
X-Gm-Message-State: AFuF++l3sQi7uUX86OUOYcf7KWUo+SaaRs7EMo2bqfKeWAwRbm7qKSAO
	ZGfYnH/MfL1uJKwERZcKyYwk5Ohp8Tfm7dAYiNC26IftaYmWG2IZLTIkpyPuN8+hOAxpSnhJK0Z
	S/OKxnbjYe9mm545a1WOBo7PiALHzuDw=
X-Gm-Gg: AYBFou3j6QyQ17pPca8LDwEEe5s5V2KPuJcqXBLUh83p1xuoNKjLHL0A52sYz8Yp7ZX
	fXyfdJfrYPbk4OkG7eEz2kOUYLMREspB5G5aRvXNtiW6NC1F3BeUeWa5xZdIx7s62SAjsixXy/p
	OKMVG1yT8x2+Mbooxhj+VbZSdlaHWEntc+JShjwtzVV9CzSsyKadS0IP175wREhTX/GTptYLMCB
	k7TfAI9LYqZ0DPSZVWZJEeUJvtZgQaHK+0OGKOfx6HKBUREZDeK5uKImjs5MT40btLWNQlutzvk
	NK6K9x0+G7H8mIfAidbqtMbUNXTrG8Xmj9CMPXO2KQ6Nz0l/Pee560E=
X-Received: by 2002:a05:690e:e8e:b0:671:4b50:4628 with SMTP id
 956f58d0204a3-6714e1bbd88mr1691227d50.97.1789463286930; Tue, 15 Sep 2026
 02:08:06 -0700 (PDT)
MIME-Version: 1.0
From: Cyclinder Kuo <kuocyclinder@gmail.com>
Date: Tue, 15 Sep 2026 17:07:55 +0800
X-Gm-Features: AcwNN1WKYt_LA1WL9vjWYb6kVe2gAIA0jbDKfrsHzKDJpkWLSstkxuDMf5Ww6rU
Message-ID: <CAL8qZ1bxzBXReej7M-20HkBwON9L6NZKZP96bs7s-e=j-_Gg8w@mail.gmail.com>
Subject: Subject: TCP receive memory accounting before accept() with cgroup v2
To: netdev@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, shakeel.butt@linux.dev, 
	edumazet@google.com, roman.gushchin@linux.dev, kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: h6i6n58fz17ffd83bceuqpqo6igx3d4h
X-Rspamd-Queue-Id: D40D7A0007
X-HE-Tag: 1789463287-198762
X-HE-Meta: U2FsdGVkX19dSBmLCxS7X4/AdfsQLmXGeJPaOc0JMhc6KrCLNcbAd1hpKOEei0B2a6oylRCuHCvYEWrLz+mMXrcZgXZaDRruElAnY8B0S10fkdde4ZnKczOzq78RUa1kbDh+PkxU9W68+6Qv3fym8iaxhYeT5WRpDB+THkKLYiu2cfJX3eKBOiKH45uGb3FDug9nRsvKcxzqRbU/gPkhb2RQIGEu1L1EIo97Yj1fGsD8BBxYtWrFH39cMUiZiAEIGJve4pjafkDO4vSfaPPLZDVZt0rnHT7uhryaXMV/MGqijD01xJoRfsXK6QUNe0pjhrvdo8URtSTFohzOfl4b2Yi43071As7eIdg7PwlkmlIFHNEhPFoMt6LB+7T98IN4k+joxfitmuPpnPUGZ9CfDfVsSzOD7h/6g2cfsFIIeAORhw2GKjJwB74N/la7I3iMOnHJ3nPAzZWnYLPptO+/k1UMDodPLnHYf0U8Kdh326yqqtcjoFvCoBYQl3p6gi1UKlMADH2SZWi8sYY0f9wnPPWEKMX6iWjyPmRepnh9WZ5Q3ceO2m+qKqxEa32TkSG0b/rfMWuYi/R4IjPEV2vN7MRAmlU6QnkrQnp4BvGN1X+isNxJz3JnYyKj333Pkxe1KKMy21ow/01q64AbxWyyFNCrU/fWAk5w1SLzRRCMgLRop9WKo97SFvVtcaYPzTMMdiwls0N2NrvBwqtHvlNXSLxy9+7VRxuCd78AQST2LrGtazr4gYZugEOmn/xdwnz+whTuEeaGjbhzoCOJ9CH5BlTPtKRPP5sxQ5qTrHzz68RJPWNKimvcImNPvucNRDzFkzp4YxBS0lgHJzhXDoHBceGe6I9+r/3KmdREEnugWU+5ER5LLbO65+eeCCRI420bLUiVPcEke2NAU+7+KdK/F65osUTVrO4zDmgzk7JMLJ3ighnsF44NUHQuEsYwIs5XC9JhXfvZdFOJCwd3xTb
 Ms0HmJZ+
 lO7CEVdAlLn09ri2DgWk0iq6AJmr709Ny2W3xqOKmjPOmLO2VPTLHE9pUM+Uu22MJFYc4S4eiXjYGZ3hJY/IBZTfNuRdRCoN+WnDRw9fhK1KP1T69/gaj9s8nmeamkGJoMfcEo90PkcLSjF283IVNAssoSW97T4W5F5MGSGElA4B/SnvgtKBYi391aBsYQQ9a2nd0kAUKENFvO+ATfrEhw0tun1kK4zD96XVmeP++/HIA39laCsS3Sfzw7QsDGPKBT4NKNHraKQqz8LK/+xO1aaW0M+AtGakslLMAKrXmuR3MRgxRhYQQb3+Bj3hcA/df3cT48XpU4bns6x+nK9xJFhUaLJsIcvsOl0PlPmjrtKZeohPxyQ6tH3BhBWXBqNWXDBXnfMaXNa9D0d0WpErFe/2jkxoVFV7qGGwF0Wb3asSph2ols2+/L6Dih4nQrW+FkVwPIOka1rWQPDByHkiPlILRvXx/2tdGRFizQ5593xPN5BUQcN+djNZgBB7f7Arvx5o0R2CIPUx31GU7xEW7yCASDr0L0Bn5GCcD3PfIFZPoajo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

"Resending in plain text; the previous message was rejected by netdev
because it contained an HTML part."

While looking into whether Kubernetes can allow net.core.somaxconn
by default on cgroup v2 nodes [1], I tested how receive memory is
accounted for connections waiting in the accept queue.

I understand that d752a4986532 ("net: memcg: late association of sock
to memcg") deliberately moved memcg association to accept() time.
The discussion also explicitly covered data queued before accept()
and charging that memory when the socket is accepted [2].

My question is about memory containment before that happens:
if an application delays accept() indefinitely, how should the
receive memory of those pending connections be constrained by the
service's memcg?

Test setup
----------

- Ubuntu 24.04, kernel 6.8.0-53-generic
- Kubernetes v1.35.0, cgroup v2
- Server container and Pod cgroups: memory.max = 512 MiB
- Private network namespace, somaxconn = 65535
- Server calls listen(65535), initially without calling accept()
- Client runs on a different node

The server container was privileged to set somaxconn in its own
network namespace. The host's somaxconn remained unchanged.

The client established 256 TCP connections, then sent 64 KiB on
each connection, for a total of 16 MiB. The server subsequently
accepted all 256 connections without reading any data.

Results
-------

Phase                                     Pending accepts   Total TCP
  Container           memcg
                                               accepts
Recv-Q       memory.current  sock
Baseline                                 0
0                 8.49 MiB             0
Connected, no payload          256                        0
     8.49 MiB             0
Payload, before accept          256                        16 MiB
  8.49 MiB             0
After accept, no reads            0                            16 MiB
      33.82 MiB          25 MiB

I used ss in the server's network namespace to observe the pending
accept count and the established sockets' receive queues. I also
read memory.current and memory.stat in both the container and its
parent Pod cgroup. Both reported sock=0 before accept(), and
25 MiB after accept().

The data was already queued on the server, but its receive memory
was only charged to the server's memcg when accept() was called.

I did not exceed memory.max or test memory exhaustion, so this
does not demonstrate a node OOM or an absence of other network
memory limits.

Current implementation
----------------------

I also inspected upstream v7.2, although I have not repeated the
runtime test on that kernel.

sk_clone() still sets newsk->sk_memcg to NULL, with the comment
"sk->sk_memcg will be populated at accept() time" [3].
__inet_accept() then calls mem_cgroup_sk_alloc() and
__sk_charge() [4].

I also found the discussion explaining why simply inheriting the
listener's sk_memcg is insufficient, particularly when a listener
is created in the root cgroup and passed to a process in another
cgroup [5].

Questions
---------

Is the pre-accept accounting gap an intentional limitation of
memcg socket accounting?

Has temporarily charging pending connections to the listener's
memcg, then reconciling ownership at accept(), been considered?
I realize this would need to handle different listener/accepter
cgroups and the root-cgroup listener case.

If that is not a suitable approach, is there another mechanism
that should bound this memory on a per-service or per-memcg basis?

For the Kubernetes change, we are holding off on treating
somaxconn as safe based solely on cgroup v2 until we understand
this better. Pointers to previous discussions would be appreciated.

[1] https://github.com/kubernetes/kubernetes/issues/134194
[2] https://lore.kernel.org/all/20200222010456.40635-1-shakeelb@google.com/T/
[3] https://github.com/torvalds/linux/blob/v7.2/net/core/sock.c#L2542-L2547
[4] https://github.com/torvalds/linux/blob/v7.2/net/ipv4/af_inet.c#L761-L766
[5] https://lore.kernel.org/all/CAAVpQUDUULCrcTP4AQ31B5bfo-+dtw3H8CQGq9_SQ7d28xXSvA@mail.gmail.com/

Thanks,
Qifeng Guo

