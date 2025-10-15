Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB73CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 20:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720F08E0091; Wed, 15 Oct 2025 16:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1BB8E0057; Wed, 15 Oct 2025 16:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C12E8E0091; Wed, 15 Oct 2025 16:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 480B08E0057
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:49:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBF4687229
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:49:29 +0000 (UTC)
X-FDA: 84001539258.13.3936B3E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06024C0006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:49:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=DpJ2fZr+;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf28.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760561368; a=rsa-sha256;
	cv=none;
	b=hcv84G3JbiXIyATLIqX4Db/UBlpGhtlotFGooJ+to6E3Mqmt1RbfOR5eYJ2QG++XViniQG
	1d93F4Yx6UY27X5mQaXRAhxOPTPVjyyEVIF/JOrqG3/dEvvuwnkjiBWNr335m79qV+UkH1
	W72cd8u7TeTGC7xcA8C7W/u5QJrRGqk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=DpJ2fZr+;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf28.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760561368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auiaq9bXtW9OcLEmzCAQsL1QWCboNbAO7KbnHsw+v7A=;
	b=2Wi5hyzxdVB3NjxPGH8rnYEvotrKaZq+2MmWEADO3OqvU8JyUwGUDFn4wRzSkC/EzPsvxq
	Js/DGaRwUvOA2l+6lAuNNhfmpkhs2jPFYgJAYFeBT5KvPxA3Bf4zO1IW6bFwPDnniz8qWB
	VCIFCVHXXp+g5ySaBn4d7J72z0JFtwg=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7800ff158d5so46200b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760561367; x=1761166167; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=auiaq9bXtW9OcLEmzCAQsL1QWCboNbAO7KbnHsw+v7A=;
        b=DpJ2fZr+JC9n13mvSZjuJAgtywqe8VSe2fxq+lsZuj2HNnzUAA3FnmhigUemqM5dCQ
         iYjz/6Av0Mzt7nfXaFeSIbslPYTcXijr+ryljdAWlts7e/Dm/PS+iDHV3bNFLB8hIFk2
         LOTlk2uwDBE/ymjteGCp/j0zsjGgK0rxVnEae815+uprnA0/xnP+9y7MX0A1+DesSc58
         5uPu3hYbctbHVrQao1udiAIIWGeooRpsRX3B1sgNCIcXPFf+fdYSDEOaaIXeYsRUZjFT
         0qE7LbGSZAOqoAutvXW0QIfpn7clvzrfDMrCHLTu2N+0DRAFWpX9nH05rGoZzX7pcK53
         cCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760561367; x=1761166167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=auiaq9bXtW9OcLEmzCAQsL1QWCboNbAO7KbnHsw+v7A=;
        b=YrXmJGnXG75V7kEiQkL5k4BQe9tpU5mgl2e9jPFuMgZoEp6OxPTJaXehIPk4p1rwu7
         tRzPLsJTqmVr5PY9CcaVp39LFFpomg/Ze++RHL+DQdO6IyHVuvcSkhN5yjRJm6QALi/S
         MmSEvq34tiwQW2Ak9mmam6XHi2avl+Gs0f4t+E1RqC+L5Ceg+ye1KmEgKa0yu63s5IgD
         16NJu6/9rQtTbVU2KfuMUufl4crA8S401YRu6oSVAUtFLLfX7f/nGyZPPNimuX+DtsYX
         wjhZcKCaeCSw2W53ilHM49Pz7DPcZxfnTMBHuHVG23ehn2+pEzMbZGWsl9b7t36zo2PL
         1LQg==
X-Forwarded-Encrypted: i=1; AJvYcCX8L11F/sio7ID6iDYZ0VeR985QhUTPDqyh3+KISOQNkf1KiW9mCRNQB7vYwTRpgQKjbQ/ZqyZN0Q==@kvack.org
X-Gm-Message-State: AOJu0Yw4YjEjQRuWucQT4AXYmrkfmcVQrSuBMbNU6RwoHVxNsNyIY1Hk
	TpYNsS8P4vCKQ9Pvgol3yD0dG4diFYm1WWaqHxDgQXFM5JfDp4V8+Lzv7NqxlX2NAtU=
X-Gm-Gg: ASbGncvoHp4vlpPRB0GMI7aSRI3wublOA6DMTyeDRLFKFiVTCmgfjvkJb0uThmb8Vvr
	KSh8jcQBvmXzbkl3d5gzvUdTdCua1PSorX8DAn0Wu5c0vu5h4ODrHzCnlNztjyRx5v58h6XOVVD
	4D5gnMALb/E8Mf2CHJ92bcuVyDjpQgR5sY/voKRMLDOvfw0DK1eFGZmGGmzJoXL0hGQIgJ3xBTP
	UAr3bDJrr0f35Z+XPFMM8Cn+86jTA4F2JO6xjFR/L8FNaTdI6DQaw5uE00ya5P9xZXPLzdyvBoT
	rXIBAlAatof9n+bb4RjKOMjW7oecAL0FLSEqLcd3x8Gux0CiHUOGOa98PWXmALxuA81/5NABANq
	fmoe4wG6dQXg5NAHNczj0j2AvOJljrzwY4VlZDClIETrH4nIuAtcr7a94apKV1/zeqS1xr0Osm9
	/yLoi6nvFm1UA13uAG3mpbzMNF046ZVCSIw/LAsI6YIKla1wzK8kVw67UI8mtUNg==
X-Google-Smtp-Source: AGHT+IHxmIPwCOfcZsbFhwrxgWT3gZcy36a1nJDg9vCya37PskWUDI/8725jdDe3RMayeVo56dRu2w==
X-Received: by 2002:a05:6a00:1406:b0:78a:f70d:b80c with SMTP id d2e1a72fcca58-79387826a86mr32369735b3a.22.1760561366355;
        Wed, 15 Oct 2025 13:49:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d0e2774sm19762406b3a.63.2025.10.15.13.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 13:49:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v98Qy-0000000FJEJ-1QPI;
	Thu, 16 Oct 2025 07:49:20 +1100
Date: Thu, 16 Oct 2025 07:49:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <aPAI0C23NqiON4Uv@dread.disaster.area>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-3-hch@lst.de>
X-Stat-Signature: ty5c8wr6zumm96mypyuaxrej1mfd6qba
X-Rspamd-Queue-Id: 06024C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760561367-252583
X-HE-Meta: U2FsdGVkX18+YLzM7W5K3+Aq5+kYLFZ5DQDmqrC9RsbnpNN4qapfNRa6qjT6m42ad83Nwh3Ir/C7FEx7l13SYEBRsVrWbWh8yj2yPS5YTWfWevLzyw6plLzzFXwDYwblUvQv6Ib3MxGZXNCe4v1EjoX5epmlMdk0aKICpyGEipucqMfcUyZnXxmQIttWmiSyo319QxerJev2B8vNBH4kk4b2daoVkqwGalno0oUawL5C37z8iuQqqVIL5j+wdz6yjp70HfIdDCLtaqa98uhm/YnVJ5Oo8VZwwxH1JAy/fGqODVkd5i1ojjtG+K18EQjkU9DKAHPm7KurE6Bv1hePJnj/TnCUnCy7qKNq4SsalAPe/o08nB5g+1ZvxBDN6dVfCATUB3VNhKEIaDgv6fwVQ4jS9MaBA6E0E94fzomvTYoGAasbmwg18c+RXW1NZ1JiUq5+Hy+uNJnAZz/3mj2kjzZnlZjXBfM2qu4sjIzx7M4vkvcMKiGtts330IbNt9VhmmvWN1XLs3Urk+VWISPDH9/FvWGT+T2TxmYBCwmPEQ+Wul8pqHvm8HiRmgd97nJoKbWyFelP5YUJu3o8HX/hZwfnjlxJkLkpscrJpkUzhZtEvK54NoyZf5jdbR3AoeQxUnL3eQpLxU4fHVauwy2wwFnn0WODwnisqDACTqQ3o2yArPDEa4Y+flVPUjEe5rthkaKr95F0JZbvgKokXcJ5/aN7P8N7Zfw/L9Xe315298M36Hl99cTOTfDpvF6uIXavu3W6P6mKHmjym037zDgnpFFJk+AcRwQRy1P2kYyChPsSkaGTLnNDK//pHD+JHyq76lSqXHY7WycF7sHFeCXexiMRji4nvJ0228iQ1E3wjh5GFNWDOr4hl0aPRq7L7qyWTUlMEm4kolDYgXzIIMJ0mf18QzB4NRpM782CDEVaI28MNwUkR1lQMe8CTRbAnDG5ye2XU3BbfZcTThLziSN
 eKf0I/4v
 LOefnECQWpnfPc6W7zK9aFepv56vNuPYFXFR/O+wHg9AcufrMCzlTOxMEbMY2Ah1aL+RG9YJh6KRaQqa7r4TyxXIhiU7I5n2nUeH/Yi0xNtLiIXDJaSWg1vYq0AwA6GtTtyAI0L+hVlP/CclyHxyktklzTi1Cwwff4TIUiRBANN0tupD1xuljGEIHX28YPLmefsBInIzpFIrdHDkIatNiwmTJ6ju3nx6KDDHNLzQ0wVsPdk7oJSrnMkCEZg+o6l5adOA/PjGJEzvgbvdTD5UzMfgUTqgGKYVmU0EZDsUNDAaF4UqAVTQtAwZUeuOb7uCs1veczup1XsHWlgVvmci1fzERt58CJ+CgPEeeEhCXbDSxjbvgLfzS+0tSkb0XheoKdKrVZO+8HFIgcgI+mdY8Y9eRFolV1smod64utrKQN4GhAAwNY6ikTmk4uS+NN+8aK3J44tyLa8FWrRpBZTzVQERLUWQqa9Sj3HGHb3rLio++6aU6FvN3PqlsIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.

Hmmm - won't changing this for the zoned rtdev also change behaviour
for writeback on the data device?  i.e. upping the minimum for the
normal data device on XFS will mean writeback bandwidth sharing is a
lot less "fair" and higher latency when we have a mix of different
file sizes than it currently is...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

