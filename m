Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14DACA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 03:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CAB8E01CE; Thu, 14 Aug 2025 23:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5034C8E0002; Thu, 14 Aug 2025 23:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A5D8E01CE; Thu, 14 Aug 2025 23:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2447B8E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:03:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B0051607CD
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:03:58 +0000 (UTC)
X-FDA: 83777497356.07.1D53ED3
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93853100008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:03:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZBeKMx6i;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755227036;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3d/p98av+5p9WSBdtxvzNDj+UN/95Nc/p87bn2DC6M=;
	b=I4OYhJGLohLbdP2YFX3FgvAzTZhqtiMpuF6/6G3J5cH1IeEJLetEXd59DUJCoWMea/HE+3
	Fwnlw6kEiGVkg3e2ZvxAD8bEu5jJmn3bCE75UuFAdtKW3EojgwYCoaTAODqslPuDPwhxrp
	lFCCegLxoSL21+v3V4hH2HTaisavaB4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZBeKMx6i;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755227036; a=rsa-sha256;
	cv=none;
	b=NC4LPO0pbgufE8b/eDib5mCaNFTGbqjp2PtjzqvBg4ZqTT6tVVBnyYPJyGqPfeq5SXpvXp
	jX+YRs9+2dM3tX7r4pX5EhLIYE6+SG44nTnL+z1PuUB637+1z+yyOrYfL9t8nTHojNG/Zu
	+uM7YfvgvPMX8LhpKciAypty2H5AwXQ=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so203332266b.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755227035; x=1755831835; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3d/p98av+5p9WSBdtxvzNDj+UN/95Nc/p87bn2DC6M=;
        b=ZBeKMx6i0Z0EGQKI8A5aTrK79A1yjBglPfZGUAXjTwdeJDL9bFtJPfDsUNgVywrYdo
         wC0ppZIefE1zAMfQ6orClFdvD10tot5NB0Wz5+9gLlL5uxTbQyX1YT7XNJlCpiSVK9ww
         nymcj0V6WmwJcmtRQNmhfHCfUS7mXqKo/lJcmd8/iG1DEG4I9M45Ed6SNcE9kO8hO3mS
         LV42QfjkLJdGuTJb4JhbAMF0K+Whr9xfJUsbi/VD02ZNlvv0J2ZDBxzL5cn2QvZRw9pz
         GA8SzWKLuTe7KsjB24Ds1q6oRjLk+AKEiP/fh9Tn2lMb9ZAJPRjj21aBGBXxHPebFSPI
         iA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755227035; x=1755831835;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i3d/p98av+5p9WSBdtxvzNDj+UN/95Nc/p87bn2DC6M=;
        b=kAQiyOOG43KBHOP2LUJfsuffsMVP5YaS7JCPFP672AvwF89ITMFtYYPBf/0eRDPPCl
         uxb3AyWyO/F/7YMH3hh/8VFCiJi9h7nKcGLjj3idMCUz6oTfM5mDoZ+0ZjBPoJOVgyTf
         UJL7WTGKH8NQ121rqmMGLZfmST6fqxdy/6HHKGRD/G5HD5cOuYBB0HY6sT8qWZGxfdD/
         hWaqG/AAjnx/edqvrZwfsAF/uonOL9/J+OMpVcJkCJ8V1NuxiyCKBb49mcw3MOXM3Zf7
         mISYAcHCabdlQyCoEvzAocowO84OEr8yhPDA5Ca9sB2gRfrOt8DT3pAx6XN2uqUhdrWO
         V7uw==
X-Forwarded-Encrypted: i=1; AJvYcCWObQ5hOkYBuxzwDasbvcfpRZcrctmQ0lxd4yupcmZVaSg2P3SJr/VwlvGyB549y8TxAXQyYOYEyA==@kvack.org
X-Gm-Message-State: AOJu0YxzKlyeoN4S5f63r+/ENUwCEJ9ypB36+ggkX8y6uYqEOQwKINWo
	s8OZCN9b0xOBQ+wsGO/GpptnVwj3nfNEaSkHSW0tLXyzcmc5xm46IKMH
X-Gm-Gg: ASbGncv6eSaxagfP4aCA2tLItTouyy7yKZYuaW+1EvbGfJAtTAFRBeoIj8FB2Zpw9Ff
	IYeZhFWARaIcLKhBdwFhjBg2GcECCo334fAcp5d7dSc0EVeZfkbnVNht1S5mR/UEsna5RwgIbJ9
	o6/TJio/V5OBvpMMy+Obsb8HZduLNQSccWsuDmFZuQOcSJ6P4ThKf8IUmTiOP9Lp+wM49zACXZX
	oY81W4SRyr/kqV7wuvidSZTNqmZBm2UvhbNpV0h9Kn6E5kITHyRIommxX3Ghhn99WiaHo5hep0R
	yHGesw9gYC6gtSEcR9WMBLoVd3UKMwcyaUrSOzs1XwZlmN9v1hIT3wzLAVSbslCfKxnPrO/Z+Qp
	x0ymuyFphEVOx1zeuvSnAaw==
X-Google-Smtp-Source: AGHT+IF+lAZM91ReYPwNbswbCM5l5ckkM05Jg+DyCanBBq8z5Gts5vNv6UzeXlo4zmJYRRx+LGwLnQ==
X-Received: by 2002:a17:907:3f22:b0:afa:12c6:26f with SMTP id a640c23a62f3a-afcdc1bf1dcmr37711966b.26.1755227034718;
        Thu, 14 Aug 2025 20:03:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfcb2c6sm23132566b.60.2025.08.14.20.03.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Aug 2025 20:03:54 -0700 (PDT)
Date: Fri, 15 Aug 2025 03:03:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 2/5] selftests/mm: mark all functions static in
 split_huge_page_test.c
Message-ID: <20250815030353.rdppdwizz3b2btb6@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815023915.1394655-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 93853100008
X-Rspam-User: 
X-Stat-Signature: gyxgje1c5c9dr3keq64ei6xbobydtjoj
X-Rspamd-Server: rspam09
X-HE-Tag: 1755227036-136986
X-HE-Meta: U2FsdGVkX19o6FLij/S3iJ80tasfV7NFwZgIjeKvVuQAMWrw8b3QeiDF8pF4VO8FDp5a7ZoDgiO8H1wh03tcsqMzax1RNK1S5/lVf7AnPX4TCUMI3yynVQZ+/hfbFEEjXD6KEWb72C0EVg0kG8Y+PfDG+O/j3iBUn3NbyXRjxxz3ZkhATKllG3I1ezyzmtsE6XMJtG2BdQRJ9eOfexG25KtWdhcc3scnya8P7PmC7DUxmwHXjZlvpZqIXBkwnz4fRDyaBOV20rnY4NPMa8Jy+jfV+E8nqyFmwRMsiTXxpbypRzkvvNYzNvq8fz2HDbtFYsffImb+v5v6Z5irm7pl/4lNaLqha4ZsqsHy/s30ZNs6uHy6drIZS3IfMBStwxjDhb729Jjktq2LsX5kVlV5QrC6bYx7PQ51Ku+yruKPcH4q9BeiaouyjMBs2ohjskUwNX/GKM3Ds2mYi0gtRV81ABc/9vQ6I7HBRlKcaZBRyo4n1FBUE+/P103OvXHJbH52Qy9rLw/9LEqUIPyAT/I93nPNKF5r2zGPQvux42UNd/BCNaSfZ6SQHwDiXCVSY1vMmzwQ9EjmOAi+lxoefgsaO50epsHYcbYbr5rV4t6q0027NTEvd5DhcNbTEXBRyJdUYGiXTaCWb7WDO0ckqQZpdYHFwM2WK3N33TzvE9k3SeumAdMokkLj5IHfpHM19xFsbEbwJVAt0jFhq3nb6+6S+rCJwRzAo+lRzZ3TM49FKe24p2wLxZ69TO+GFWIl1hp1chDCcp5J4Ee4khAMbp0yPZrfe+r0q3zmsavF7FIrG55eKjiHk4zdmCRsSmYc9q4e34ZUH8OaMTT1sSWLi6l/7AkswwBvJs4SL/vfrnF3Rx6dxsdk2APurvdUhDsqpw7/rxnyG/JrUaBTVuYyAN5zfrtWfmg4i/zbMfXoVfT3jNtkpJlQ9Sdn6b0WMO0s7mdQAUkoWiUSB1+2yg1CBXD
 bALYTe6M
 xR0VE+JgRXlbnCN+r9MK9fVCzOJetIyFAlmgXzlST1y/D8JOWyih5L0JO7tSw6VHjvwbLh1GDRp8zwerJrC384byR3PQChlP4TZEK8iukA0d8veTUQt5zvTQr3QoP2yYDkF7qTJMr2SfAxB6kAwOCB1bjby0U1LfOleHCNjjvusyTSFEk6G6qwN0d8P9LG2ompXzMUY3fy7OtyfnwXaz7tTS+kt0DGGgQUMlulEGjLI37UlBy9SCvkiDDZQ4O0mrFCF6S8wBYSrQUsEokXKJJ0C3hrFRCnCy0wDNWFxYCYEzpwXvdy6updo6sMQr6AorJHSFGt0IWDGDcU3cbqxrBhND+BDy0Jv8VgqiVp4b4h8O9XftGVLXXVCpKi5639HhKcQ1Jk/NFv+0POAT9KItJP67/7FfUshZmYXWCxjtwoDQbClpAjYI2Y2DpB8/B/CvZD5zWvRsX5eB+dUcgIDWee/VRg+eZjO+c2eVoqerfntS4ul5vdxVQox2BMY8UxVmvHri93y/lQ20abR3MaBwQQh7IgH2HCa1CFgEzAUk+PnRdB47NZ+OYaaRLsZg7wJ39gxvv62w7yjWYTxp6BS2qmXoZHzSB8adTz70hXj2dxzY97NFBVofBdcRGlwSRvQbKA1cwTOc05IiacbEFEMFvezTwO35CVfJ2HpfcIw4XcgSmD36Tpr3dbzG7+XGFuz715R42/6xbjrah2NW5KV/JldoswPL992pfDXYSuBFRipnecxYY0sgkfVUMw7NbtDnczHXBvK2aHG7XrmvkV0ERGn9P5InXXqAgoUCkGPXXxTw28ryTwn4qeEW8nRd6Ctlch9Ft
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:39:11PM -0400, Zi Yan wrote:
>All functions are only used within the file.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

