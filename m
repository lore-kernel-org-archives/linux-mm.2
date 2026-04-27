Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F747FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB77C6B0088; Mon, 27 Apr 2026 13:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68466B008A; Mon, 27 Apr 2026 13:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57216B008C; Mon, 27 Apr 2026 13:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95B036B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:15:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 438F216021F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:15:44 +0000 (UTC)
X-FDA: 84704987808.02.25507DD
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 385C5180016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:15:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bzlWr7mF;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AakHsZlEQE9Rq1pnBFm3m7E9zfrXxQ6QJvrADxUHjrg=;
	b=K9pbObt8QVPLgKOeuHMQbcCDGAEkWom0ngW3WV6YUE8fZMQeRrNQg8hvnQTlbxhtRCuqA/
	Lql0yMrVXFymYMvgRX82FhJYAXDX+q8r8crdM5omHiPmbVQYafx4wE7YnqBZYh8Xxrsbu6
	EquCmDzRcJeO10bwQdYeLxmYHudNy3I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bzlWr7mF;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310142; a=rsa-sha256;
	cv=none;
	b=dzSJLab8Qz9pJjTKBJtj8Ok2/jnN4DhPX655jfRf2BDX25UHTnex7LhiR3KO+6NHSx3iVN
	tfP8kC7ChMvZKjLTfmLAchKqnQ54sy4SKjyUsHKAr8Y7eUoyZkADcj2U7KgeFOh6M5jGii
	6nuZhj1FtehJvjDkrlk8tnuAzdcBk5w=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43cf8d550bdso8970035f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777310140; x=1777914940; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AakHsZlEQE9Rq1pnBFm3m7E9zfrXxQ6QJvrADxUHjrg=;
        b=bzlWr7mF7x7VT+y814w41+yDa5iNSrYAaJG48kD6scBkBX2XSB3ozsW4bqgA1pyVg1
         ORLDUck47KiazhBVhNboUApeSzS1ytURpIQi2u0fOlEYEZwR9PWRaJFxsJgfGIyy0Bk3
         8/OU4G06XsuOSbfNgxbLkU8UwrbvUKhCfTytke6gV1qPpAYrw32CFBZdYIzsqlRylF0l
         5G88LhJIHNNUfkSGVMv5geQoqnDagYTgKl8DEFeW1TPBp03G19Lsr7mYHQ2ln+3Bwy9k
         FbbPIlW47DeU+YAu7H2a95NykEWzta5Bnm8gn0X3+PlF5A4nu6zMBXfJc/6foFVmJe/1
         Zk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777310140; x=1777914940;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AakHsZlEQE9Rq1pnBFm3m7E9zfrXxQ6QJvrADxUHjrg=;
        b=r9Hrs5HxQWcOGdc7KeybYvQQQMWGC7P/ekDCDUdHHEHrtixcVLTS1IxmtH40LGZDua
         xFxgl9RoTiRTySxddVhoLVRFC/GNhck9pruQjtK3fczjaZ0uRQBGI2inWTLYiIOyHZUO
         l+04xUMR3iKRfXZGmhYlDbGHPx/pV5JqC/fQRbwhkDH75+6VDAc1J1w/xfscWkEsvaOB
         CnEkrQvqQ+/FO3ZFx8YjQmFiP2h1NYq+aGoJW7sQPWYu/qlZvatPieDq3MuCz95KD5Ac
         Np0oQe0Os4K6Jwm2aL//DlZfF7Na8joIRksJjSGLX+iM1qS3wMNuSP3XVQDxQ0UYxB+X
         3egA==
X-Forwarded-Encrypted: i=1; AFNElJ9nZa8ADPQRFgotWpgAMfvWEBvCEADA9yLRSyAIHrq37ubYemuX4xKtPqfsUnNqxj6OYxITKYsogg==@kvack.org
X-Gm-Message-State: AOJu0YwU8hCoEW2d0FNPFsPYanMhmbvr0XkSB+KxiBXmfBSm3jIrRj1X
	NLQotiFexJdzET2Vp5DEqwhlNY8pYtvcqkZoWjhlCunw3r6Ip3B9PhvvGmq+Xfoi21E=
X-Gm-Gg: AeBDievt3SAF1BPVhw5eRuKVWFbLUMTQCN2rhdctUffq5b+4cPkC5MWiDciTS07PxvE
	QhBjhcX95WmKExMLphH2MUbyJtFpPALLHz5EgMMt/Am3CH1SAsia93Rg01lp3crG8skn6bol7QZ
	dG3ud9OrofCFqL5e8chJigDcy/3i4MxKgIC27/j/0qFCGnEA28H7CAmCCTxbPMe1gU/597Iar0I
	TfoL/NtXHS4oS95kfzJmMxqUjEs8gumPNgJ1GG1oM7Vw5Oyj67mWvsF8c/7nPdxtJcWM1a64FfN
	FSJx5vTeIqzAkEQmyhJEKsik0FFeXcGq1zcA8SuvrPHqtG6X9rS0R3om0Uj4Q8LZe39cB0fvVDj
	QH3mcwAUJXPiCIeQGHDnNMzrQm3cyETZ9qusZ4DM6gWxG7m46otDSuPy5YTOP3Pj07ware4/Kze
	hF1nLOcRJvIn2QHWnV7xFtDGTjIFsPwCgUAiwWglGiFXx/kKA=
X-Received: by 2002:a05:6000:2902:b0:43d:77a8:3baa with SMTP id ffacd0b85a97d-43fe3dc551dmr69959006f8f.3.1777310140368;
        Mon, 27 Apr 2026 10:15:40 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44123d23e0bsm41748981f8f.15.2026.04.27.10.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 10:15:40 -0700 (PDT)
Date: Mon, 27 Apr 2026 19:15:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <ae-Zu-VAzAA7SdLa@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 385C5180016
X-Stat-Signature: 6yxn4p4g6bdbcippotkf35n5so8jh47w
X-HE-Tag: 1777310141-308934
X-HE-Meta: U2FsdGVkX1+rgT/Fm/01JCBWX1g/MY5APJ346Tgf7Ic60Sx9nDO9zjEAibgxLwZog1XRYN3q2E+jo5A/fD/phoLW4zzQgyk8ZbMNvTcvEgX1C7iNd/2Q+dOZGglUkvR5WPqQgnmX73WT8YVre7vjgLXljXGfBD3k/9/8WULmRjTWabs6W2V2Idf4NnbjL2Kds7rZqHmVovT5fM3bFH6ZKoThaXofZO3rMvzZQzLJULtAYm9Odx4hY80/CsaImNpWs6VjxJLNhaZcrxMLQp2yNMU4Pdzk4rZfUseNhu46rwx256mmPA0L0uNrgWobhBX6TrF+uV3yOikDmb2eS1cFhWUL7VVP+6a6aMQQVBXkx+aPjITi05GMEd7rqSbT9QWJsM6Q3EP00hGu7DE/WLNwCftY9TQ2keqUIp7TfNtmzZEnv/OpOx5vX6LHyTnUzOKPsh/lJtxzjuQ0A3moK8veVWR7AfxnGHs6FNokQgoWN8uEIL2Xyf0b7vJXYZPQ72F7r8CYc/u81VD3e4+O+jQJUco4yPd4Fr0bkBMVlxCN2R0NNofLNqXsH+5jegq+T52Fe69cqBXXiDUFBAmS4fnUuiCVYq8R2j0bBmz5froEGocnv2APXwDtQxT1UAROaoFGf1dNrYtvYfsN1RVJDga1+0kfipAZq8G6HQ58X4DLZS8C63gkha5RZkGgApnMP7PnTlhrnj8oOaywwFge60JMBilLVskXoTaU1l/72AqOXWUhrHWvvknL3PhI73iXJJ63H4g+aYyTHx3KyL3ZtzlS/Ah0oTsK+qisPtmYK+VZkJQT9vM+r3GsXNvWwwq+EwpoL5wnsbToOa3zaw8xl3z7djrHo/AQ59ypUFD88JCklSG1RQ7QoWfIzyvQQN/lzNUN6QYGFndDnIXGaIv5RUoQ2zTMgAQKnNY9Q5i66gYQ3/Ulli13NU3VOtbveUrwgfs3q8LIPIOUAu7DBPZ/bsn
 xgAIUBax
 5QHcpOI6MOHckPuFDzKGQuNYQ0/G365Ed+8QnvqTZTvP51m+cCqE1k4muKKe1ZSdSDS7i0Culb8Yklj7CvZ7rfPvDof++0ipIfGHBFIDUYIYFLGNjtBAz04JhXzxeH44OIvSvKXfppTea1DKN+Z8q1AH4FQMS0LHmfiEVr5OF1Ijd5rWGxjHIS+K67X/lhafQtqLKGD0TlvpzcUmKNSVau4LN8LAbKC2ced256KbpnCHdRuI/apH1FAHN2katXCNY41tHUkvbWZERof7lFzBGuB9K7LAK1Ak9iyDuvIfTGb6xGI2TAKFziM/Widfu4IkNon3kVqz5XUmwEbZ5jHACaj5D5ZSv+pWKU5UN1I6A3jep57STMaWX/1haXYX4KW0oRKlqTlxvc70W+VFaw09r7xyml6R4H1xDmLYTxJAYHTpTZdUMymdYAndxmw8ngGOnGnh6xiGnaZUoE5nzsvfGr8Sw6fvTxeQksM7n7U4WjTI6yCTNzMOI85RiUnf9MiFdRhtymbCPUWcjULsq6IVZDdpP9MOLtzIavwJMxrfLPDd99sb0juEy9RzJbmy9cf1aOxITNkn6zq09VF3aBZKQctxS8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-04-26 09:48:28, Suren Baghdasaryan wrote:
> On Mon, Apr 27, 2026 at 12:16 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 24-04-26 12:15:18, Minchan Kim wrote:
> > > On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote:
> > > > On 4/24/26 09:51, Michal Hocko wrote:
> > > > > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > > > >> For the process_mrelease reclaim, skip LRU handling for exclusive
> > > > >> file-backed folios since they will be freed soon so pointless
> > > > >> to move around in the LRU.
> > > > >>
> > > > >> This avoids costly LRU movement which accounts for a significant portion
> > > > >> of the time during unmap_page_range.
> > > > >>
> > > > >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> > > > >>      exit_mm
> > > > >>      __mmput
> > > > >>      exit_mmap
> > > > >>      unmap_vmas
> > > > >>    - unmap_page_range
> > > > >>       - 55.75% folio_mark_accessed
> > > > >>          + 48.79% __folio_batch_add_and_move
> > > > >>            4.23% workingset_activation
> > > > >>       + 12.94% folio_remove_rmap_ptes
> > > > >>       + 9.86% page_table_check_clear
> > > > >>       + 3.34% tlb_flush_mmu
> > > > >>         1.06% __page_table_check_pte_clear
> > > > >>
> > > > >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > > >
> > > > > As pointed out in the previous version of the patch. I really dislike
> > > > > this to be mrelease or OOM specific. Behavior. You do not explain why
> > > > > this needs to be this way, except for the performance reasons. My main
> > > > > question is still unanswered (and NAK before this is sorted out). Why
> > > > > this cannot be applied in general for _any_ exiting task. As you argue
> > > > > the memory will just likely go away so why to bother?
> > > >
> > > > I think there was a lengthy discussion involving Johannes from a previous series.
> > > >
> > > > That should be linked here indeed.
> > >
> > > How about this?
> > >
> > >     mm: process_mrelease: skip LRU movement for exclusive file folios
> > >
> > >     During process_mrelease() or OOM reaping, unmapping file-backed folios
> > >     spends a significant portion of CPU time in folio_mark_accessed() to
> > >     maintain accurate LRU state (~55% of unmap time as shown in the profile
> > >     below).
> > >
> > >     This patch skips LRU handling for exclusive file-backed folios during
> > >     such emergency memory reclaim.
> > >
> > >     One might ask why this optimization shouldn't be applied to any exiting
> > >     task in general. The reason is that for a normal, orderly exit or just
> > >     pure kill, it is worth paying the CPU cost to preserve the active state
> > >     of clean file folios in case they are reused soon. Preserving cache hits
> > >     is beneficial for overall system performance.
> >
> > This is a statement rather than an explanation. Why is it worth paying
> > the cost? What is different here?
> >
> > >     However, process_mrelease() and OOM reaping are emergency operations
> > >     triggered under extreme memory pressure. In these scenarios, the highest
> > >     priority is to recover memory as quickly as possible to avoid further
> > >     kills or system jank. Spending half of the unmap time on LRU maintenance
> > >     for pages belonging to a victim process is a bad trade-off. If speeding up
> > >     the victim's reclaim by avoiding LRU movement and evicting cache negatively
> > >     affects the workflow (due to immediate restart), it implies a sub-optimal
> > >     kill target selection by the userspace policy (e.g., LMKD), rather than
> > >     a problem in this expedited APIs.
> >
> > Your change effectively boils down to break aging for exclusively mapped
> > file pages when those pages should have been activated. All that because
> > the activation has some (batched) overhead. You argue that the overhead
> > is not a good trade-off for OOM path because those pages are exclusive
> > to the process and therefore they will go away after the task exits.
> 
> I think Minchan's argument is that mm reaping occurs only in special
> conditions (under high memory pressure) and for a very specific reason
> (to free up memory and prevent system memory starvation). Therefore
> priority in such conditions should shift towards more aggressive
> memory reclaim instead of normal aging. I can see both his point and a
> counter-argument that this might cause more refaults in some cases.

The way I see this is that the standard memory reclaim under a heavy
memory pressure would likely encounter those pages and aged them
accordingly already. So this is effectivelly racing with that process
and makes a potentially opposite decision.
I suspect that a lack of memory reclaim, as implied by the other patch
(to deal with clean page cache), is the reason why this one makes a
difference in these Android deployments.

Unless I am completely wrong and misreading the whole situation this
might be very Android specific change. The question is whether these
side effects are generally useful for other worklods. So we really need
much more explanation of the actual behavior after this change for wider
variety of workloads.
-- 
Michal Hocko
SUSE Labs

