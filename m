Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3EC6072C78
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=O0dhtEKU
Received: by kanga.kvack.org (Postfix)
	id 53B5B6B05B4; Mon,  2 Nov 2026 12:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ECCA6B05B5; Mon,  2 Nov 2026 12:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0E26B05B6; Mon,  2 Nov 2026 12:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 124726B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:29:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 890CBC01C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:29:47 +0000 (UTC)
X-FDA: 85390866414.28.906AE46
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 803E3180005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:29:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O0dhtEKU;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793640585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBnwm37qIsrm7xDbTxm53J3mLY9DT6w/4rBjRvoMZdE=;
	b=TLHu1BtPlL0edMHO7nBfd0WOLW+muoppG5a6SkicnQg3gXef+UesA5DeC7H5g7o0r1cMHu
	/ybWe35IWidtRfVQzn3mvFBaWdfZPeN4wKWVa649KGiowHKK6Z4WRv+HQOMxYcka7W+Vf9
	0hkmAtY/aofQ+yETE9RVca7c+aot+zE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793640585;
	b=xEIn0sPpYZXZxI7jFIh37yh9ne2bjnb/NUwxIy3oTnzp+XITEU+EfX+edsObx9KwwMd5lW
	WmVyT5S5S9k3GTO4a909zILcKmZ2TIDmVJphzevUMtD9icz/4aOtIX+tz0O62BnRz8aWy8
	AuchgVUhutcpy8BMWUnqRRzlo5HVxDE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O0dhtEKU;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48afbd2c386so1933991f8f.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 09:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793640584; x=1794245384; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lBnwm37qIsrm7xDbTxm53J3mLY9DT6w/4rBjRvoMZdE=;
        b=O0dhtEKUri/gHfAcwNxOyPqVY4+cQXkUHRKi2jyMraRAqXLD4FBLjuGTwZdDN7YE0P
         t5Ti6uMJ+tkWh8sv3JUWxFddpvtEzDUWALZ7KB1TDBkKdtWRp3nPFOvnJGR+Jzz626PY
         ILaclFTl+sHXfFKG933hJCt4+qZtJIOGsglBqI8a1Km9JEhXENFFZKR+dpP/p+HiMwRK
         rYo8ASDflthEKy1GDTKvtp7zJFTlA/K5YrHL3bRYjwDgeT2LKngUgyaElkko6DeVJSt7
         RW8TqTxqWkZUnGwfcD6w/zA1PTBd5sdci1dhR2x3G1ONFERfi6feubS+ovFZdXlPYNPz
         vxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793640584; x=1794245384;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lBnwm37qIsrm7xDbTxm53J3mLY9DT6w/4rBjRvoMZdE=;
        b=TIUHCZweHuHzzNr4VYON4qfirYzLLQ8pOidGrWC6d8i91pI+acqn853Dn56/xawiTe
         pQxeYYfafBGH8PTMVInmyDjcy2WBsTI+zL0TiquSAqe9NppQtaQVnzqIvMlH56KBuBAj
         c52te1rOZltiVihYvwOW67/bFApgpGo0G8M14arrStqBvRsmeCDQ59xLojPgPJ92r1NX
         hRfTlkYwmFtXV52GjvYH0SwQy0hksBKH14HKz57X5wTSfGNldv6IEe+Uq9l5IRBNOuvH
         l6cbYWe87dW85da+Z1eOBoT4oYirhWfTjBTTtA0zF6gjUhxHHobCJLr7k4cBc7xsNe6S
         MTGA==
X-Forwarded-Encrypted: i=1; AKwUvByuwCxbTRsf8ncBL9j8OJOgxQXNMJIxHZ4WB3OGQdEnG0VbZbJww0r6oS6nF6/vplNYeuPFq6HtgQ==@kvack.org
X-Gm-Message-State: APuU4Z8hPQXWWvjHf+jEHx209E0fLn6FDnTFk3GjVei/FQxKlrrNlyR8
	PMnk/1Bd6wzzbns8oRfCXmS7MTaLl6JzS/KPpXjihtomobvyJX97V1UtXSuCHzxSI9c=
X-Gm-Gg: AYBFou2qFb4jU2dKeEmFPTFkAq21o3xeko9umz01TUvKyitsk9HzANXacxHcwtUtwTp
	18KhOF5jEpDeQPeeUVlJLMImh4qShijt4WYtuK1xuD2nDBZk/jGOHOfDYcbI2llUxnLJhOate3i
	JXKWTubgYLTXRw3IRpbzdOjaIMmHnMoSUbEORBr+9a0rFwuC0+EbfErqAiIaWgzTIIs00FPVhxE
	BgPB59UOXmb5Cmdp5ptLYVQuEajdywn0GjDKBdwVzGGlESz1aHngBQtaWVayMRD0xKPkmdOsf8S
	oWxZq7Its72iSLXVnLVhPXUEA4vSSE4um/0Ph7g8CeMplDO7q7nZplUeUMso/nWOHOuxPJvyI3g
	ye6nxTY3tULPg7ljjXTz7vQDS5VT1IIvb62sWfevQxaKosEvpSK5ATkhs9bzggRCnrCIG+4YB0K
	er5I5JWoUyfytkyAPdbU6s0t7fkwM54HVPKlvsuapYv6E4sGlSPce+TIuO3UUNxiD0YfW14zgVj
	2ghDcfoJs8GUrqMxRw3XSdY6dwflt0ZRvM8iQAioJa0CSqvGhvF9cqOvBMP2kMyqTfOXErxZlYP
	M96RQQbMcI5mdVYTKA43lDJA5guvkGPiEMNBjJ4=
X-Received: by 2002:a05:6000:4b04:b0:48d:f391:5c45 with SMTP id ffacd0b85a97d-48e6e4f8ae4mr26540418f8f.42.1793640584164;
        Mon, 02 Nov 2026 09:29:44 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80306sm22600959f8f.33.2026.11.02.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:29:43 -0800 (PST)
Date: Mon, 2 Nov 2026 18:29:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aujIhsampHnzcl_5@tiehlicka>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
 <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
 <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 803E3180005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: a3opuzxb16gz4amtpityp9d4pdckia7u
X-Rspam-User: 
X-HE-Tag: 1793640585-743915
X-HE-Meta: U2FsdGVkX1/Yz1sPEOtahH/S8Bl4r8+2stJNuNthNNUwaqyB3axDUgPa5Hg4vCMmQ3n1dMyTsd80Z+0AH5QarW1MB91g/D9mKSB/mrWisoD6InL23F2yNDOil2pWr4HejbBn1U1v+NdDU9tMCb/YXfiIe3w2hetK86CqgW0fN1RtrcP0OvxE2F5iaGqBm9oDyroiw3zPwKbOv+2cWA0wL1kwLO/oPeKL24YyDFxjNXpU+evKR2jqPAOhdh2wqp37nAA7ikxDR95L+UhbJM0ph1Zgxp6UUYMr0R+/MQyQL2WEYxEijZbjTVpEzliblgd7fXN7A6EhJV/0F88YeHH21OCgvHX7WJg5i+aW5/8gLY/32PMy31rYglgs8O76CUhg2SbIt9Q1hu+tAHswpKLAWvQPUHdLh5fV47EcU8aq5wSO1PUrKu34EOKTRAiLp7o1xfXSSKOUtrS9ognQYoaQPo5rsemVCPhaT4blWSYkPYJskmRN+pMz8PC/9fgyqR2I53cw0Mkmzm6odWHTvuW+iZDiTeDy1xaL7jJEfkStgMg2RxFrae7BRnL9vr3+ryPZ1lUm60RTI/3VnrEUCmKACpOR63pveFjnK9QeJITYZpMFFOY/1M3Nr3c2t7VgqcAXjOSXAaoS3xwwl4MzlDEoPJzDeal8X4hQPagES+hVScLVP2aG19VRARVGeNkWKEZLl2OkykH46HQuWf6uRO0lJ9875slcIDR03RMkBG+pPaZ96AZeoKsifw5NDSf4q8vIIx6KpDexR7xKoUbrQs3lufALbIFFxkojwL2VKEYgHqn5fun7v2b6rawXqTVwNN6Vv0HP0oFj9KYcypFHVQ+/Qv/Ac1KZP3MWXDcD9sDthvOrAAK6kBVP0LL1pOG28ojQ58MgfUrsXgIoWwvk5ZnZhRxGfiFSqR0gsp7UNf/TzI9g1IL2gm32Asy+fQgwMCqaZfSXeNHKcH9In8ygj/7
 hL0uyYZw
 smEBeaQcRbZO9xhv+pMeSTXl+WPmM6nq+oYTUFh9iMLlSGjWOTgNz2t0wfdiTQWqGJycmnDQCpI8kRWuC3iXFZq6dyTR4tuMjTXkPoQLFrr2d4Vw6Trw/Kmbt+AKCulPigJjQJOcAuwKXE0YiFYLQBa/FRrVEJpicUG3LQgnfOI4INWrs7dKzZzqWVhq9kO+X2R0G49ulgFNfYrHNUD885pozF+lRAaPPCyvUEi1xRdh+FAtlYqwWjHBpn0RLyESwYet5COLK+QvPUTuxJcv5U/8lR89mUNY1d5yQbdFso8U7Xvr6giFCGseIniM1E6I3x7gVQGH7P9WnHSEZjM9iDPiehIf8ScFhQhv5c1kwydD5nTkJd+uiukMHSboztSSqA7YYunH2Cjmd8p03jJAdQaCnGqP3U3U756RCD2bHIV7FGio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 16:52:44, Roman Gushchin wrote:
> Tao Cui <cui.tao@linux.dev> writes:
> 
> > Hi Roman,
> >
> > 在 2026/10/30 14:05, Roman Gushchin 写道:
> >> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> >> 
> >
> > My assumption was that v1 would still be maintained for some time
> > before its eventual removal, and the goal was to reduce the coupling
> > between the remaining v1 code and the shared core structures during
> > that period, rather than to rewrite the implementation for its own
> > sake.
> 
> I understand. But personally I don't see big issues with the current
> code caused by the v1 stuff. Maybe I miss something...
> 
> The proposed changes on the other hand create difficulties for those
> who use v1 and maintain some local changes or simple backport upstream
> fixes. Of course, it's not a reason to not change the upstream code if
> it's justified, but in this case I'm hardly convinced.
> 
> > If the expectation is that the remaining v1 implementation will be
> > removed in the near future, then I agree this work becomes much harder
> > to justify.
> >
> > Am I being too optimistic about how long the remaining v1 code is
> > expected to stay around?
> 
> Well, Idk, it was considered deprecated for quite some time already,
> so maybe announcing that it will be deleted in a year is reasonable?
> 
> Shakeel, Johannes, Michal, wdyt?

As I've said up in the thread I am not really convinced this is
something we should merge.

-- 
Michal Hocko
SUSE Labs

