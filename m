Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7ED3CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BC398E001A; Mon, 15 Sep 2025 11:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CC88E0001; Mon, 15 Sep 2025 11:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9E38E001A; Mon, 15 Sep 2025 11:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2788E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:28:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6541BA2F9
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:28:28 +0000 (UTC)
X-FDA: 83891866296.28.354F144
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBCC6140007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:28:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VvKAR1iT;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757950106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HiClITBt+CyIUIsQX+fBoErmvovdqrPoDXurgutbUMA=;
	b=dCkrmOce6ZNMuTHvKK4LuyUQ6DkJKZAA/9CxF8AsFwOphv2Jc0bz428psFdkpuNwSCf/Lm
	IgLZZ/Ov0PzUuXTsCCI8xwxc0AtvWvt3dWe6cIhyHlCpOV9FM0cLfX30ePgrwosmhhv86s
	drhgsWDBAwMrKUps0NqNS43v/z3h7Cs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VvKAR1iT;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757950106; a=rsa-sha256;
	cv=none;
	b=TnAtqAPEDCbYuTnBvh25C6SZrJc/QGAFFL7cxsDAYvCPAqXfcgkGFB76dTqPxraR0plaNH
	wV0MChrcmTTFZKgeQXFletS9r8QjjMCJDhZbrPj9xVK09WjUOgz1ay78ST2cEe1O6zg9vP
	txsJDwQeJhhxvP9/8e1zEaPWQbYH3PI=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-72267c05050so36454537b3.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757950106; x=1758554906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HiClITBt+CyIUIsQX+fBoErmvovdqrPoDXurgutbUMA=;
        b=VvKAR1iTNo3j8JMMzAQnAa69gJCvKNxUNJYikriHSpMzi8RbbQoRpft2uu1M4JjuRG
         YE40YtHczLGmlYVswxfjbp/xO7zhQD5hCnKtd7Ef6ghlR9iBXUTA19NThcBmJCIh04J3
         Jgo7w9GJM/zPl8kFG2b8pqkiq/NW+jJBrFvhvsvbt2ijSAiQFWCvaG87JrVB81ArKjco
         QQfRBQNnJQWLRj0djpWBnRCw0ZIFppfa5u/C7pYlcwF7oG/qkzxrH+I6FtJtebTYo/sC
         4WKdr+MyXPGMKPItdpglnHfip07YJq85AsRQhSDB+nSo/BdQgzMXFzQ0eboIMdUz6XSQ
         djig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757950106; x=1758554906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiClITBt+CyIUIsQX+fBoErmvovdqrPoDXurgutbUMA=;
        b=Cc3+eudkCebtINcu7EmASXiclE/ks3+j8enxn0JoMsG+na3RiQPTnjl9HPdijx0Vue
         6qtSqopzCedkiPY879a5WD2s1RZpdZapCkazXNBY2/ZB0N0H0TxMmQlOXMOYPNhpeXTv
         WKv8JP77L8qVinjZvPCeJwwIkdfQpUjg/DmameYQK6wL/R3Dvb4mu3+f8F0na4mWDmnl
         qcW+f9TTFoiYuHMEzOUpOvU5s4T8Kzc4rTcyr7Rs63TkVXdpOttiwwZTQFIriLjNJJ/O
         QC9XQOdnmPsVxVTCrBG1K35ur1roNBPsWw53y0uhXrL6OLo7b0QJOpRRDSYr3KMEIkEz
         5VOA==
X-Forwarded-Encrypted: i=1; AJvYcCXYndINnoFxmtA0HqNA4iGCARswLm76dqOvL6LGHfBSu006Bz343Hgo+GOLzF3uPseKNUXdHtN3eg==@kvack.org
X-Gm-Message-State: AOJu0YyrPiZIYO0XNtJVXEQscwMcx8oXnCu87icaTdFWcJpJNzQ27fDC
	Q7hh9UPuStoU8aoE3p5EKFv6hW7KSJ3adCVobzJNflirD3cFY6bUxnjA
X-Gm-Gg: ASbGncs9PCb619b92yMUrEmB1cp17fqv7Wdf/4FHplnr3mJkbn0u/j6zvQajoo8mAB5
	tPPRbYPgp1gFt2NcB2dEkmJ3DO1+KxVekwdrDKf3Rw5ujFEc+trNoiWCC9GPaxniN7Ty9IhNzL3
	fudwP5PHQyusdrN8EHvI9c2uDp9qMBp5JoNXPTNJRkoo3ZMKVgckmQEsmeNtue/ef4kfAQRcoRT
	CwkDVOpR5C88C1x928cG1FDe9s3HKS234QF3n8J9SJgElzGEHSimg1xBVsT3n8dAfpPKu67m2vV
	ule9CFzl6iRBNtobu74707Bjfoq5qSQbddhdv5aMMZlgJs0mOIHIJydpvuOOx/GGj0qzKcCbAGJ
	I/vg+LbGWhwqzaW8/a4RXFDLO7A56QTjaWaEQUTx7PKg5LcX0uEv42w==
X-Google-Smtp-Source: AGHT+IHLKoGjQLIXfH7bFgayvLYdDgcTU1x7NMyUkMTH4LT0uz24DJ/2fWVkpnpcFtkckwGwJRVnpg==
X-Received: by 2002:a53:cb41:0:b0:612:891a:9ecc with SMTP id 956f58d0204a3-627202230a3mr8701789d50.9.1757950105297;
        Mon, 15 Sep 2025 08:28:25 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:42::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea3edad05c0sm2586944276.10.2025.09.15.08.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:28:24 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/6] mm/damon: misc fixups and improvements for 6.18
Date: Mon, 15 Sep 2025 08:28:18 -0700
Message-ID: <20250915152823.1605591-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAJnrk1ZHdt-sj4n2VigW6u6bnd-gX47WpUfaHDxqN1BH4JGUXw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BBCC6140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zt7nxs7tyn6dd7so1ajaabxjbhjhbrk8
X-HE-Tag: 1757950106-380314
X-HE-Meta: U2FsdGVkX18utzAQGkn1KksbeICZch+1Ilm72HUdEtD9m+K5M5rlFX/dDfEbK7kVS197SUhKV1bIrmcFjAboR1JBlJ0xx2AIEqhpjjxhOvUDzdjSr8M/u3BAvKcTU4Uhc7NTBwdA1PWI+Vg36Quamo2fi4TcAI4bbTNZH8JeyeojA0O8Nr1v6A+owAtkyf+qXWA2Ny4d4dQiK5l4Yp9yz45N0aoBy3C2T/QWimRlR6MsnamOk4XXeJETmRDG5rIgyJ38vuwbMhwNqDapOSv91uMJ3P1+BDX3VH40QmarGtCHEB3TA+1Y+35SBNI5Yd2wMJqaUKrvYYEfNv06qx2+NUQdewJBb2sY083GO1wWnWFXaTT82jb9ZUqlNNHSCbvfCNMQfClP9mBEuJmzpRmf6s1QwX2Nxn3cJw4SBL+V3av6OzT88xj2eVMdudNbavYv5y45UFcT4lP8+Lo2XgE4S4Ped/loSap04JNFjvoTD3qm3K5MZvT/v4jhc0ayodntAgICyVTrDNyrJoB++CAGR4LKTT8EXQbQXuUgwQtoAZC4h2myq1aOtpKK+g5mJRutG0sR8xSRlNSSC3E0aIDuURi/s7EtOLjsGYH9Bmlp/gZ11faPv3CKoSu90OknBkBJsDulw7jSbWDxJ6l0UmnxEFSOdiFnnTBpDQnt/JMx5K5s0N2DM1z0JpHghYzP7veqxr5YVFWF2FJVaY/NkbWa/N4L9vYyqlkR8hNbMbfP4pyN+HbZOZZpO0EnGpkquZp2JoSZO0NkhPH7RRLzgZge4GXBWfkuCS0mKrEu+DRQISbSxrbAB1ZB7iPgOqK+VFx1mwhJWH/PKEQwuvzc2tztpMtLh8gX4bj3o7HkVkb8I3476ZFfK+3lfY2fUCoZ+0hPaYXCsMWCH0bkaL1QRligcqyHJgT5GKXnOSB5MvYtHIPVKouYbTTVVrkf+Gr23D0DkoYWCV33Yr6lay9q8+I
 zBPMeWUj
 WJ5lScycbO6/0jvi2ZV/tVk2+yGyWgDPYa+x6LNeaO9DnoyB4XsNClLHsvBFlaofdLRcjAH4c+hUJvDhQEmuZQlCDzhE+o/EvUm72upqqZ3QmR5BjU98bKRUu8kSdi9FJPmEW40YNh+7rwIOfLn/SqdkjJWQIQv2g1kdJUYGe1Cq+GIyUFDTCHzFs9TxJExa9G7HyLaGQO5027ugpqeta/IMzS8SHKURFO+pl4jWIAR337yqNodBf2/KKZCBHipd0oCfFSjYDFtkwg122SaCef5b/zjgBbepLnpSPCZZUQoQE/QRaXrIyfWgX+ys7FUiu0PmdXvPSEywBfqYYq36I1/Y1JpFAW6WCT6Rty3Ci43lWMMPPtkwWTsG+aDKFrjCh4UPvbwx8Bmnr2UwKrLYukoKsDbxQ6GcCRzqNq46qamP8cIiLhij3ii0P76HLRtXfBDPItMIqF9Em79zIyXVfB6rqiGEPFN8S9CVPKAb3lbPoxFktIhaiVFloRu7W2TnhjxBbIqmvga35NEQo1hDZYC4BSKEuhl8rFhKtQAVxLjWLnFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 08:25:40 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> On Mon, Sep 15, 2025 at 8:08 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > On Sun, 14 Sep 2025 18:58:01 -0700 SeongJae Park <sj@kernel.org> wrote:
> >
> > > Misc fixes and improvements for DAMON that are not critical and
> > > therefore aims to be merged into Linux 6.18-rc1.
> > >
> > > The first patch improves DAMON's age counting for nr_accesses zero
> > > to/from non-zero changes.
> > >
> > > The second patch fixes an initial DAMOS apply interval delay issue that
> > > is not realistic but still could happen on an odd setup.
> > >
> > > The third patch fixes wrongly written code that doesn't cause any real
> > > problem but could make code review confusing.
> > >
> > > The fourth and the fifth patches update DAMON community meetup
> > > description and DAMON user-space tool example command for DAMOS usage,
> > > respectively.
> > >
> > > Finally, the sixth patch updates MAINTAINERS section name for DAMON to
> > > just DAMON.
> >
> > Hi SJ,
> >
> > I was unable to find this sixth patch on the mailing list. Maybe it got dropped
> > somewhere? : -)
> 
> I'm seeing it show up for me, this is the link I'm looking at
> https://lore.kernel.org/all/20250915015807.101505-7-sj@kernel.org/

Hi Joanne,

Thanks, it seems like linux-mm wasn't CCed on the 6th patch. I should have
checked in /all! Have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

