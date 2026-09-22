Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4184C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11C66B00A7; Tue, 22 Sep 2026 04:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8FD6B00A9; Tue, 22 Sep 2026 04:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8506B00AA; Tue, 22 Sep 2026 04:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A17146B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:33:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 657B9140433
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:33:03 +0000 (UTC)
X-FDA: 85240733046.06.1E85B1B
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70444A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:33:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pINoIXiA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790065981;
	b=ipLIAmSSBGkIg8ZUuFGmPLQqI/5hrxLYq02knxnopKY/2NsGep3hvgCrqCRHft5K5qCbhk
	GsPrZATVMzsIfhKScY9aq05cpUQiR+a9grq9uXhlX5Nb8krXgS8GsUzA3TMNtKFtKIg0EU
	1soB8vkUiVYSZw5VOOh8EVk0Ass3CS4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pINoIXiA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790065981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uc6MKy91deNZKs3T7MFlI/Iho7lcnSF5IHtT7sXWVmE=;
	b=uGS8nvgWLsXt1rF2vRAlbotqd4V4r4qnicddrOKtAJVPatX/zHvIsrDt+Uu8ZozfNMD4xN
	WTog9poWfJdUI6IJLRUWeMTaqdbcuxx14pq6ikCUPH3NTLoQ6BpyMJpDaLnMMy8Ah1tPLo
	TLJ9+HdH9k9ofAl2xxipulSL6D/1FXc=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d4e39e3d8so13761107b3.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:33:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790065980; cv=none;
        d=google.com; s=arc-20260327;
        b=i37PrfyAO9ErWNJj3ObwWlse1py7X/SFPGjZFYL6e8wldKNw/jnsj5J/LzodUe7iur
         Kg/TKgSRZeMgkLNGIaFVZ4XZ3icZCkHCnZVsFd2AN92IWWSZd1iNF7AVtuYi228JKULb
         CMI5sW5DN6r/AJBRIhhjRagnXQaa00uW/jRDiLKYjly8m5VTLP/Fwqjhy4Dm4bAq6Lqx
         SvKhM1q/P+sU3Jb3mM10rLByGSjB/oyQYhvJgEihS1Jrk9QjeZQSsonTrXqlyXLb5SFu
         JczDDwngRTsPKcmiShK+8omEinpia0TRcxn6w8C0X13GnE8YEm8JpphMr1zhHwO83/Jk
         +OnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uc6MKy91deNZKs3T7MFlI/Iho7lcnSF5IHtT7sXWVmE=;
        fh=wEjGzvkG1Tq84OdguHbg7mulwb2U/XixYze5hS+QYfE=;
        b=RbxmMSnykDd+BGTNrBynZT5+sMSlv9qusOC7BQwM2OOtThSKjOhtekROH9s7/2V+nE
         YBDt+go0uA0OETvfFjbnOs29Jh8HTbo0JJblzjn5yKK6qDrhOQt9T2T88SAhLyY3Mzm3
         8Dk21Nl5P32HdL1IO53ulgdIOB2vpgGYMoykbCHlNdN9JOILCAZlcHnh7+k/eoGzFX3j
         G1Tj6BMKftB58R72Pc+37Yr2dGcJXVpRojwP6MEwmMEqjDPNA//Pg624jvUn3/PMIzHs
         IfbeAnqqvX3mG4DZuSQiZZIjTGIhwrZTnf1RFD/SP8IBEDgnbbSmgLEfMq1nyI/CHn2q
         PBQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790065980; x=1790670780; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uc6MKy91deNZKs3T7MFlI/Iho7lcnSF5IHtT7sXWVmE=;
        b=pINoIXiA6xldzxsWHviB92z/NlNK6ie7kukAfql/SldA79qhfT6pfGdqAHMuVd06g7
         spfTCSKf/QlMWxV/M5L+8JfR8B34MpYiOsh9+I3+WJzPEnwQrZmO9gu5wjGLgHBJ3ucB
         /Tid3HNmIMpmsm/aGR2U+ViJr8UAeO1pmvHB2i2gLyOo8S2PxIWUpTr7oEZP2wn+zBtm
         XVQUI3A4qDiTvUMATH+ReCGvi1UqlXVpTvXvtdDJH3/wJ/ExIkDHCNrSa3m0WjptLRrc
         kaeyQcPPqQKR8T4ahv7Xs+ULl+7ur0xfIAM5AXVqiHEBqLHQR7uMK/HWTPmynfOejb/2
         DkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065980; x=1790670780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uc6MKy91deNZKs3T7MFlI/Iho7lcnSF5IHtT7sXWVmE=;
        b=OtlMZnqtvRmkC+lIltjz/+zpBe9uGeK48bkNv5m+VnS5fMJYevPmg1jHRVhE7DzWAO
         m+0mOROaThUdCpvsDzVd8hCOGJYLFZorf63nBBaMuqAqQULlzxRpizC5y2kp0iMkML1q
         tutLF7uvawRQMOTGPzGGq9hoSf75YsybgM+xsv2WJ1/YPeGOft6NF2fi0r19DFxc6gaI
         V/PM2nRPAIz+z4zS1aAptIyKzkwCsZNpWh2mJlWiYbRqfqwxgCqsvtm33GVe+1+SwZlK
         uMGwFpYGjgpVV0RgygRjCIl+xTOx2ABSOC/VaqnKMZO6Q/yXlQ+V5ZW7yLve1ajMwcwf
         ho6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwBXSJfBoSxeIJiS+Qo+mYUNJnCi6jzhGmIPCYS4VB87ENcVzj3UMh3H/XcyR33BGqngZlpKQ7DAw==@kvack.org
X-Gm-Message-State: AFuF++neFBCqf+SffRnZ6vxJuODwJ++jVSilN1Z3Ynj1zaP6TJh5/hCA
	6DUh7j/2Q86FP9ue8J3jaZGMuY/9fa6mKVv+lnsIhguxD1exdrIw4pZ7sYtoxcYrNu8l2CA5+4f
	5GLK+v4hw9uNhBGTdTT045rUj22yXepg=
X-Gm-Gg: AYBFou34JLTnJXdz6ERNgGTpiPJgQ+vL5NFu+3/J4YHyl5J1uxsYBEktxu5BeDq0IzV
	6z6dt7z6Tn1eaO7QZp7XxTKJO3TlF/vEhZqEQIh2X/kPcGp+FAnZQp/VWf0I0mBFPS/CkUoCIsw
	WrBw0OtH49/0JfEAPKjU530wZxDHvKHSC32Y6306A5GVL9kwtXZnsQhzr+GA3D4aL2xSV/WZujZ
	7FLxFgMhSctoJTWBF6BapmDB237jRYeYyA8bF9Noba5mCtQ4xkTNmSZ4z9w3jD2KWU6s6p3NPEx
	GIsAJmb0UnCeohoF9SRGUR+3slU1QAMcxGNsP6t3yvtTNTx2t9N0XD6TKhKTVxBHgcpUDcS4hJk
	t8vLkg6YXi9JM
X-Received: by 2002:a05:690c:e3e8:b0:890:f416:7a27 with SMTP id
 00721157ae682-8a1f72e0763mr10172907b3.19.1790065980502; Tue, 22 Sep 2026
 01:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260403194526.477775-3-hannes@cmpxchg.org> <20260918022222.22955-1-laoar.shao@gmail.com>
 <arGNfQQAVRZpEoPl@cmpxchg.org>
In-Reply-To: <arGNfQQAVRZpEoPl@cmpxchg.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 22 Sep 2026 16:32:23 +0800
X-Gm-Features: AclHuK_94ufGY4ZEJ8CT7PtJGb648vSJVIoVUbgHFXl0QAzoGNj5hW9JaUB8nVE
Message-ID: <CALOAHbAQm-Ev25DvL=SUM24mjUQojq20mqpFC_hBwepaurCz1A@mail.gmail.com>
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam.Howlett@oracle.com, david@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, riel@surriel.com, vbabka@suse.cz, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70444A0004
X-Stat-Signature: d1qpk9aeu1nby5k1szau1whap17wsqn1
X-HE-Tag: 1790065981-197457
X-HE-Meta: U2FsdGVkX1855IKy2YR1Jx7OjvEWVMmw8AoBJnwrdFX7WN3f7rEveFoIZQxC+xSljVDBy6PpxmxptQrCwP4VcfU3Ma4CE8urEFF/BmtEccRMDEnd+doAwr9/3PrI1HF5vaTPC0iIjCP8i8p2D0/8/ACDGCTz5ZV+lGRZEQfL25awPTyNFeohsNvuYIKiXzoMqd/qN+lnSUPEln2BlHsoIHNqLXL8b3U0Oknv8wYBTypECZ2fpJKU+0qH+DZyJPakH0WFNA65NwYKucBdnBINVEYBYz536A8XWp0TMAOPg+ysPBQq29zZqpGXMHFwyhvniDmQB8Dyr0RfIGy/v07041uoNMR9TvvCXuX461WjKJZrlrYpKSI4Uu4/1a4D64QiBj8D272JCLvBe7o8cT/Np6gKN1F+3CiXHzguhoHJro8dB96qBeQuyGyGPN9TFCip6AHWAY1or1t3kZDqmeoioAErpfFIZsr99tfRpkEOvLmeBjs7w0DarzXByRrT0qhvWiO2PozOHD35lsgzp0Z7UEwvz4cRD+ppMwIFULAvP8OjGqpFTVEpkF/ZQVS5wxr2lde53miOQioPG1k2eKCuTGO6LgUPjEyrZkhvtR5eGBOrcGZpzv9c4QV5vuAFqx4bDBSnXs1XS7kD8xQ/iZ9Sh0GEX70FiRDUZDHjaaK31xKyIE5RUwb9M84EmbB7P7OiE/nl935V8avgx2v9v+hmEedIL5/PFSBeQPdEPb7/tB48Ky5wpozyjJ9PiCSvCeNgoxDi6kfJHt79o8LRhXFkr4GZ6YEZ6qhtg7NEiNdMZtNtVKNLio67wKnqjrFHwUWIuyuIw44oVifmns4dkOnYjVGXf+Do8KdvqSNn1JUAMvnvHgrP/EYQwPx+wy5mpyIbpmyzXGT8CmSAt64jvBLHphOjxiMf+dyVv7wmtJkXYHHOboe2Pe9PjHcUFPUBOQ5ftWLxPSdREf9kcC4vndO
 UOdOwCei
 xHjFYZKCetERU9d0YPCgNqUGk7Z294LyUs7mG/VAlkJfldgID8jwLo21vH+GprwMnm8lL2uQrTkimpY6jyYRpSXMVpXU1US7o53NJxqT5CItotgzMcrFdhxGsQgytmsNoeEP5ivn3OoS+k6xekpBr3ZObd/sqDFdVGSxCIw2x8DWYWkdIpzaDKQnAPSLmwMw5eV6GJQinDAYIHALRRrKPfMurrGBQvWTb3OpFRF7FBLg0OxU80LArms0EJhr7xw86Ut0RsVTI6uN3fhec7/coL4VeDGZkOLIpGkjW16joESdL7qnmtz5GFbCi+/vQQyd1qmnCLVb8+fwGQekWjryvWA72S/fuJUuhhlK4NNRHyOFyx3AuZJW3xxILkuu0euWFccg20s7atdD4UYg2rlHAQ5l4KlwqXVWfPpz3wjwduQ4K5O9d4viEsv2vsWbPwNs/vG9Wc2M+vHc9lqtB2V2o89rx7CkQfAPBUr8/gboDJ15BwsMVkmYJe6puMUOFtFx0fBY+HHT+o/g2Rvr641X19oqDFzKqsxyQb/t02JQ2HPdNcIT+jrkJpGwQOjkIVIN2FXa8kCEtt9Mfyv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 4:03=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> Hello Yafang,
>
> On Fri, Sep 18, 2026 at 10:22:22AM +0800, Yafang Shao wrote:

[...]

> >
> > Hello Johannes,
> >
> > Thank you for the great work on this series -- I hope it is still being
> > actively worked on.
>
> Thanks for the kind words.
>
> I am still actively working on it. Since the last iteration I have
> addressed a few things:
>
> 1. The locking bug you are seeing. Rik had also run into this during
> stress testing. The fallback to the zone buddy on PCP contention
> brought back some of the original zone->lock contention.

Right, I noticed that the zone::lock contention increased slightly
after I applied the livepatch above.

> So instead
> I'm using the zone llist introduced for lockless allocations.

That is good news!

>
> 2. The PFN search for block recovery that Vlastimil pointed out. I've
> tried various solutions (counters, bitmaps) but the thing that worked
> best was having the zone buddy itself maintain free pages of owned
> blocks on a per-block loaner list (in addition to the regular zone
> freelists). This eliminates the sparse search altogether. Recovery is
> then: pcp->owned_blocks -> pbd->buddy_loans -> page. Every page
> visited gets recovered. For the loaner list_head, I'm reusing
> mapping/index space that's unused in a freed page.
>
> 3. Removed the unowned buddy splitting on the PCP. Vlastimil had
> actually asked to try that separately, as an incremental step, since
> it's self contained. I tried this but realized that part was actually
> bad altogether. It violates the rmqueue_smallest policy and causes
> runaway fragmentation - just like the new block claiming did before I
> added the block recovery step beforehand.
>
> So now refilling is just block recovery -> new blocks -> unowned
> singles of the requested order.
>
> Incidentally, this also eliminated the CMA problem that Frank pointed
> out, since the other refill paths respect ALLOC_CMA.
>
> 4. I realized I'm also violating the smallest-first policy in how I
> was mixing owned and unowned chunks on the same freelists. For
> example, an order-3 refill from singles sits next to order-3 fragments
> from owned blocks. Only owned fragments, which route back to and
> reassemble on that PCP, must be split. Unowned singles must be
> consumed at their native order to preserve smallest-first policy.
>
> pcp_rmqueue_smallest() could check the PagePCPBuddy() flag to tell
> which ones can be split, but that introduces another sparse search
> problem, where we might walk higher order lists in the hope to find a
> splittable owned buddy.
>
> To avoid this, I retained the legacy/unowned pcp freelists (up to
> costly order and THP), and added a second set of buddy freelists up to
> pageblock order to the PCP. This way the rule can be maintained with
> O(1) list checks instead of O(pcp size) scans.
>
> 5. The on-demand merging at drain time proved problematic. Draining
> isn't exhaustive, so it can attempt to merge the same unmergeable
> fragments repeatedly. I moved merging into the pcp free path instead,
> so every page is tried for merging exactly once, which seems to
> perform a lot better in performance testing.
>
> Overall, it's gotten a bit bigger than I had hoped for. But it also
> looks much more robust. And the additions described above seem well
> offset by performance improvements in tests so far, even on smaller
> machines.

It will take me some time to fully understand your work, but thank you
so much for your great effort in resolving this long-standing
zone::lock contention issue.

>
> I'm still testing and polishing right now, and hoping to send a new
> version soon.

Great

>
> > We are suffering from heavy zone->lock contention on our production
> > servers as well, so I backported this series to our internal 6.18.y
> > kernel. However, since deploying it to a few dozen production servers
> > running workloads with heavy memory and I/O pressure, we have been
> > hitting hard lockups at a rate of roughly one every day or two. The
> > hard lockups look as follows:
>
> [...]
>
> > With these changes applied, the affected servers have been running
> > lockup-free for more than two weeks so far.
>
> I'm assuming you saw an improvement of zone->lock contention. Would
> you be able to share some numbers or observations?

The result is great.  Below are the observations from our real
production workloads.

On our Kubernetes servers, many different applications (Pods) are
deployed on a single host, and redis is very latency-sensitive.
Whenever other Pods exit simultaneously, or any Pod allocates or frees
a large amount of memory, redis easily hits latency spikes, and its
P99 can quickly reach a level the application can't tolerate.

This issue is clearly reflected by the TCPTimeouts metric in
/proc/net/netstat, since the network receive path also needs to hold
the zone::lock. Before your improvement, Redis's TCPTimeouts could
reach tens or even hundreds whenever other Pods exited simultaneously
or allocated/freed large amounts of memory. With your improvement
applied, TCPTimeouts has stayed below 10 and Redis's P99 has remained
acceptable. After I deployed the hotfix to work around the hard lockup
issue, TCPTimeouts rose slightly, but it is still far lower than
before your improvement.

--=20
Regards
Yafang

