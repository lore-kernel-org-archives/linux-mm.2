Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C0BCD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B456B0005; Tue, 12 May 2026 23:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBFE6B008A; Tue, 12 May 2026 23:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611AA6B008C; Tue, 12 May 2026 23:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1836B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:30:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0129AA06A5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:30:28 +0000 (UTC)
X-FDA: 84760968978.10.344289B
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09AB0140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:30:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QI+qkzzz;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778643027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=pqkZzYqVpdf77W53Sw/ScZCotUHs99LkzilZL1EWsNI=;
	b=arhEiFVw4oe6lNJvuk4W8Vk7DV6Qav/pEiUOk4evtLtzKcg5IhLdDJxzEZZL0DUDgaChbP
	QDwCf3CcgLpGrsY8eXxFCLqpQl/Cy42OxWU7nf+Phwi+0P63RtYlUVL+UFuD/qCaMPmiiM
	p4Z07KmghDUWsrQrEiwk+KkWXEHfwOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778643027; a=rsa-sha256;
	cv=none;
	b=ZvXmqpFiDhvpukRELZwxiper8NEz0HqEKPbJhrcB5dX8YyBvulxvLJB41Gbe85tmyRHPJS
	uVOHN8N9WajE2g/lE4xb7nJAYDSiCxdcBtJsZ/6QuQrPqgP9mdljCqH5RUP/p3jhbruslV
	uj32gD8/sglYLU+ZTsI9EP3CcY8uGCc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QI+qkzzz;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c796163fac5so4489434a12.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 20:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778643026; x=1779247826; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pqkZzYqVpdf77W53Sw/ScZCotUHs99LkzilZL1EWsNI=;
        b=QI+qkzzzelLmLqagzxdnyfRZECh/e0QQ0QkbNwYycFt1A+XbPDyKbwhY/k7exyZtHJ
         +GKDubs9iRh3UNbl48ei1FRa8hySSYlHS7CToNF0f23VDjIRLkryDYEDSbK5p9tHxFLO
         3CBlimsTWDDwDOB8rBfe+2hbuixaEiLV/bzdlU0OXD2H76MC2JZKVIU+3ezi1JgsANMs
         HWqN9OeH1R67iJCqgLJOEyeGV71EicW3gg79wHtoSjnfXAWZE4A35c3z59+5T849EbqO
         yFwztkS31wfuIhpsEifr0JkMW7+s6lYv4WbW+/qezZVWLfKXtPsG540YksTmZG7weTOJ
         xxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778643026; x=1779247826;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pqkZzYqVpdf77W53Sw/ScZCotUHs99LkzilZL1EWsNI=;
        b=fOt/tT0DzUz96Zt1ySHyI4HuZQ9SKEhjPMINgpGVkH2nO19Ub+6QO3iJ2cs4mZQrUQ
         S1bKAMAN4n1yEcyweRDuAJqtFTKazoxMzBvhqTPDHQolzAV66GPVrxqY9B1B/irYm7mW
         0uq5muDieoreKlNuDkXCdfN1EvmjLHsfeZ/pXz+y31yG4MhAj0vUZd8S3SAHXv61hqAb
         vx4zdH6/nsNdgHhzp5iM++gMpyOjHrXc8uJfHyV5gFfMBs82ZqKfYI9OeGRwHGps8cSO
         5uMnOW5A+GKLgbK7gxHNjhdPIySM55+0RG6nKU931mkJGzeocP7TYAc0/gjtej3wC6ib
         VpDA==
X-Forwarded-Encrypted: i=1; AFNElJ/aLPOxGdQdJAZdivXeI3PvO4g8vxDzWv4k7kT2HXDFZOK/ksvm2KcqbNCe38ccXOY2UpxW+CcXtg==@kvack.org
X-Gm-Message-State: AOJu0YzkXLK9ADeavBB7x7ytM/7v8kmzrQQBc5WgdAbSrGH/F29rP28F
	PBhIyki+l9v7OAgUMEYnKqOHbdUBSviXw6iRuLfpUO3xq4bqOiap+LPx
X-Gm-Gg: Acq92OGB/9tW59QryQCwa/bhjzkEvXdHIth8vgPGH4TBgF+ZM3BK79KrxsnjRdlfpbU
	t+X1PVFOlNIhtaP76tbfRZrihUUDGxkWq0uB8OhzFYhNJh6AbHE2yiq1srYMcU+73czwUshaXiy
	VVx0q6zrIi0aoGH5BBg8q84+JxSKjMFG+wLi+8FdnyLYHTpy+jdNSSUYHHY5lBgTCPkD6bjnt59
	uxAUBZ1ebJsQQZVKH91vJpOwFQB2b7OZubcnKIx0PyT0bDTslBFRCYamH/bMuV4j0Qt/0uovN6J
	D9BlWD0xWcoQOZq6fR3CER0Y+qDH0P6aTXLJy8+uwYC+tFpiqLpsZ4u/peTpLr1j0zmUvhbx01t
	2saNXFB1mGgUwLWUKirLFbVePG9uJQnQfdn/fRGw/stuS+HqEVFWfg31x5O8QCuY8RdANyzLHfd
	YCGSLX8t8te/PvglIvGE7cfQ==
X-Received: by 2002:a05:6a20:728a:b0:3a2:ccb5:abc7 with SMTP id adf61e73a8af0-3af809790b7mr1486042637.13.1778643025638;
        Tue, 12 May 2026 20:30:25 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8267710262sm13455532a12.18.2026.05.12.20.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 20:30:23 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 8/8] powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
In-Reply-To: <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
Date: Wed, 13 May 2026 08:55:05 +0530
Message-ID: <wlx8q9da.ritesh.list@gmail.com>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org> <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09AB0140002
X-Rspam-User: 
X-Stat-Signature: jed86f7oo9ic364k7aqhme9x4rw5pid8
X-HE-Tag: 1778643026-899499
X-HE-Meta: U2FsdGVkX1+9oATqKXSywUzTiOzulbajFHw1ziP/Mq5Ri843UykN/0Zwo2o9O03LYZX8VEC1yux5DvpUEkue/TCXLn8UL8mExDaN0wwc1Ygu4xKCcEVG5yK0XYV565MTnA5Bw5XnED9qnHrGq83NFBRsuhN9XDUN2DknR6f0yg+WuNG0kIR8Qvkmq6RKLT1liNLtNwJh+3IxVPseSZad9p5md0M2AwvmSHTOmaCUOcAICYzLK7D3kiH7tmh/W1n2/6W4nUWCfEJ8jWaNv/H4b0KYR+7v74NvRAcXvUDipykQBwHtsIF3/7aQn4O+rTwXKuoCqSjgV13tBBUL5q7vhZVbksl+Ud+9edjcc5aI+jFUqiWTmtIml6JSolzPlC+03Tl8cNwsHp2s/uJxLXGWCNbtlFLSW1zfwIhbJAzdV5PVXjNKwb6rm8zDRKae/725a70Lh+cxvxPzACx7/+W3RTQEcvg2HDVNdqM2QTv09Nmxqoki5Jhjdhn7ffD8Npvn5PhDr2nyGDXc6CH64bcdI7a4GQ/emWtLRnW9ia0WBG86tdRyilDRHQPmuxHlnThr9iMDaRnV2jSd9wF+6FNN3AZ3H9LsxV5QYLCeQ5ovLuBOW9DASJ4n/yj3iBSNmxGdXT0NxSgQdDKdDj7RG+soE0U8GWDptRrUKlqyLYnDbpmd2Xn8ho4eoej8MFNauxk1IOnNQqM7B8O1Gg3EEOIgvJn2Enn58vopAHUvqfFjaP+9ouS3B5MEjhbjLb8L1yvoMdRIwqM4XvQwU42xgQvT/CENFLHYz0ECLPg68leysyC4kTespS10cPLgEqbifPMhmSaVXk7MDm932ay7bGjQWvhMAjwzsRY4Bww0Bu7wl73ARvB0sBFbtLfDZt/6dCihLiUaNDsPF8wWTykf7+NNyph+UCyIH4aq36XI07h+Gp/OzlHqsZeNhcm1GSCfM+mYwxoKT9ghW+JavCGn66N
 /ThrZg8b
 QGbGhYq95bFKKc3KdX7FLKgWCspDT8TyJUzS20feZ3Kno9DaEOH0BhRrG+nX5y+KQ8JJzOPYbE+k702MWwKGBNsMFxX6BpnByD7MW5Qtzt09nZB6gevmNwnB3SZKZopQ3gfSkgGQPB59P4cJ3deDW1liHUfnnI0Tic143pCBexIRsmsI/oQcvRwInX4PV1JrxAL+X+NYf5o8hnZqudt41xAhPzkQI5uBALKzP2a1W3ZjVQzqoCslRIaG9Qzz6MBGoPpGIQYIss81v9DQTiWAfmnJpxFhWLzZ1MABeJ3kxsn/04uY1vi3BVVijmtFwtWr+Ag3WmtVmpTWG6xRhx0EBEe6ie5Pq85LzfkOVRuoqEfIqKHxJ+O4zIPHkSTG9EwTZgquxYOYMFIrJS9uMPMdMVPfPL2EEFulSaHGPthR7DWBFvvlPuq4DTrQVpg4VmcVyU4IeOFNMgaFIZ03Up2SX4BORal/YK5TzJ/3s4uDiLEDdG1qpzz5hMDPNND7tHJI2WUpdspicvaS3JmeHgpyXy8nZMACMX9t9N0X0FCrqLXTE1qsxF+g1ggVhzydhVmQs4iew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> register_page_bootmem_info_node() essentially only calls
> register_page_bootmem_memmap(). However, on powerpc that function is a
> nop. So there is not benefit in using CONFIG_HAVE_BOOTMEM_INFO_NODE
> anymore, let's just drop it.
>
> We can stop including bootmem_info.h.

Yup, the following patch [1] removed the usage of bootmem more than a
decade ago. Thanks for cleaning up the remaining unused pieces.

[1]: https://lore.kernel.org/all/1410933504-28564-1-git-send-email-anton@samba.org/

LGTM. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


