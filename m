Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CDBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACFD46B02AB; Thu, 13 Aug 2026 13:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA82D6B02AC; Thu, 13 Aug 2026 13:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD576B02AD; Thu, 13 Aug 2026 13:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60F046B02AB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:08:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDA8640246
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:08:42 +0000 (UTC)
X-FDA: 85096880484.13.6C178D5
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED360A0019
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:08:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=osandov-com.20251104.gappssmtp.com header.s=20251104 header.b=CcB7ZX3q
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786640921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYHtd96lDOI7CnVEXFbNgDWMaZC6MCbdvBlqoNmSQ9g=;
	b=lTKEQOcIrTmC6sRbbTN8CSHZZMv+qnp9CBR/0cpcfHjruS3W5l0GS5qM2TUamwucmbgGOY
	PDegGx0t2yw/1Bf6ZOVuryi85nj7U7Qf+DP4yvLdWkkostKeVK6L0X8cCh2EzG/EMIyL/i
	/t3V+wN7uKjWeSmiAP2YqT3+usJD0bY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=osandov-com.20251104.gappssmtp.com header.s=20251104 header.b=CcB7ZX3q;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.210.170) smtp.mailfrom=osandov@osandov.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786640921;
	b=vr18Mno3MFMOtXMviOTeoAoMO3t+PEwTSrFJGQQvTfpUVaw5hvnCTvlAf7GMjIlU4cpfvG
	Ay7o2DzQJzTdePeAspjEaTc9jH0czdKWc7jVrXlrujPD4tSQDQCCyJS1qdef92mXHVMp1b
	wQ9EkMBftkx8kV341/vDVmcWre+/gEI=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e4e98d2cfso186261b3a.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20251104.gappssmtp.com; s=20251104; t=1786640920; x=1787245720; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eYHtd96lDOI7CnVEXFbNgDWMaZC6MCbdvBlqoNmSQ9g=;
        b=CcB7ZX3qmSUXYUWlnxhHrsZzlBGvHieb2+AXHofzYywSyc8eqail1lQTB0Wo0q7yzr
         tuWRiozEiMKHVTOKOq5Qg58qLoxngTIQGS2bw3zjPeYDGj8JDTson08OuI0KPA4rtwWO
         1+It2+Bt86wXd+FEDSKyujFAUnFAog1jby4pK65dNTb420MzkvH6vZ1dOMw/IXY4F9YX
         Hbhvr6XYcWfyUa7eSrwCQU1DKIvwrvPZgNeiWCT452mZnFVqUs1PnpsYLEsDA3gpD2gT
         YOAEkManRXLAiNM7eXfMNDG2qZcoF5PrrfdguyDzn5iW34N7ARngXPCMz/HaWvtlFrDA
         6Y7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786640920; x=1787245720;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eYHtd96lDOI7CnVEXFbNgDWMaZC6MCbdvBlqoNmSQ9g=;
        b=hce5WJVoUcbzIsn7+cLGE3054OHN9IGNEBS9PQn2wF5t3peU1d7o1kCl8VrrukNNfK
         TMzpFZl8kIe7jXZqw/+8zoO/6EBeB4I6ZeEnQPHVg9XIPM483aueJXy2SAGoNY1Azh3a
         rJLzq6sML+ksy0U4DV42h3h4vvem2TquXKuYO7CvJT5nhDtKu2CfwmOFT2EmMjIQXmgu
         LNA3DN00F6Lb9VH3MPdwvPQdOvxtMmWa2pndzf2Qc71CZ7GaToE1hLkcgYF0SZ57RdGa
         kdnLz5HgOLw/Yhc9YI1E6QN+aUUtJOIB9yE8AuKTT2hCdja/rI+5wu0B4wr7kkRfWO1V
         1HSQ==
X-Forwarded-Encrypted: i=1; AHgh+RqI0cbwsWTTrDxauq4g05MP+tfhc5V+ShAHCZWZEOc38p9NdTq+B+5rGrt2nDkRVZyD0PMkRNKJuQ==@kvack.org
X-Gm-Message-State: AOJu0YxWOjNpKlqiOSZk1D8GltKxtGqswGKfErTIwlePEN+woB5AF/p3
	seW2jzylDgzNMADcNKyqtx29ZZd/b8msIEBe/tDuRkNNHFcjsiKR+DHQaSHGWjEZalY=
X-Gm-Gg: AR+sD10xzalbPryR4O5JBNLphZDmlKH8j5/GfjBtGTZL+Uw3xr658wMv4V0H7JYoaKG
	uMjJDhT8LU4tBUC6K7doGdvUo0o4G+tlwNrKLza+gIxMdMBYFlcyzbJVDZKrLMnqzaxM0OnyKSP
	gy9WrltygUSXaZOcynQMOz02J6JMV6rZaqV8GviafDeWaqBfvKSqPPXCTS3MKN7Eyt8Rp5yzuWm
	/OHrHThCocT7/PSSbZOLjPiGNYvasVm7ClIaGhJmKkQVnfL605GGm2v2STjD7WciwZMQNUlUTQR
	GB9tgwlZtnuPC8/+NLqXPZX1cNS01v8aPtcU2mR55LRUdXCA2yQFVXqHbh6i6uQvv2Y4TS1EnbF
	68JnRspVWVgidsevYAV64lPJX7m5hb8Scg5fRKv86sQx0oviWlcT575xP1NCfEbdaF8TAWvXq8N
	wxT2eHecOqKGQzk2faTq59A3mHg0IMF1HeVpuWaTbIScuGPaH1vXrhYJ4ONzXj5np7b8EYYeFIF
	4Kz1vl2ChWlZ+oM3R7noMda28WA/ZxK+yN92XLlGHyITFgmgUGrB+rN
X-Received: by 2002:a05:6a00:7115:b0:848:4d4f:d481 with SMTP id d2e1a72fcca58-84fc75d543amr4090389b3a.2.1786640919729;
        Thu, 13 Aug 2026 10:08:39 -0700 (PDT)
Received: from telecaster (c-67-185-21-237.hsd1.wa.comcast.net. [67.185.21.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fc4565c6bsm1232055b3a.3.2026.08.13.10.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 10:08:38 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:08:36 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jacob Lalonde <jalalonde@fb.com>,
	Shuah Khan <shuah@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/11] coredump: allow to create sparse coredumps on the
 coredump socket
Message-ID: <an36FFL9ALwCPhEe@telecaster>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
X-Stat-Signature: gg1hu8g33s4twckgsush4kgk9np7bsji
X-Rspamd-Queue-Id: ED360A0019
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786640920-89843
X-HE-Meta: U2FsdGVkX18SWoBbCQrAWb69bsgfpLOv+IXV1mb0Uwj2jEqJePVj7KSUGFmXKMQmDw3NFgOgoZ6zJXK0bmON1qAH0+qp7Rc0vKBw8MpJ5trFwRr/71MPn3cn9r4r3/UBYIQPkKyB607fu/VG/bIL4VOZ10xi9t3a7HjLn/Oh6DAM9gpZevTNtR6qBACIaXVpAGGtD4r0pFeZxYHxeDJ6m3BEOR6uT3F3EIfUicEdq9VWCjXUv2KkyxgHAJkEEyYoslVEIn1+bve9WF1NEIHQYCGaHZzCentNaT77zrjZ1g/bICMy5t8myR69wEuX7TV6cM7boQ7Tk5EFitpSH3FeL8RxuIPpSEfW3le+FYBj2XYptWlmiDqLaFdbSXmbBdzaBmHV5d+3UNknRehToldwpO9U7e0Xas7NWON2oK1xSeHfCt1hSIZfiC3oZMrFZv8PqD7kxk3c9QmfosAVbZCzG17QMF+cE8T/Voxa5ul7A5IjozcprPRZhoF4E7r0fbklcsKl97HUAabURoNvAlhSVXGJrszRDUEl98a4bOTmnKPk93ssM8P6vu5ZTSftpAGYQlBoWGYHzUHx858I7KJyzJaTmVDQ8Ydc10qbyXBP5XrBOHVsuRrmAMRbyZUt9iLdqyMBhIezuOJLo215OkbSvusyrWx+oHLtEoyWG/FhXPPou5ROyTZAEUH46CR6ix0AcU8b5xF+Q+gjoq9HwRs1mLPtumDo8cffVXRh3SmZcgC5wGsTRLoEvCn2DDsA4q/yn4BzBcQpVWa7q1yQR1oi453hKy6Z5swAxMvNiHouLwKvVO238C0R2G0y6DY39VConL9Y0Tg3cH+wMm2EK1jo2DjMEBj/lfDD5SGY36UgYZUxfChsUY/nodH618tOOWFrkni/lnENmDDZ+z6kfiyJpUDGiMginTwZ4ciwWh+FJMI2iQs0cVa0NAjg1WsgVdvOGLF+n/6r6m04V12wj71
 c//s4pNs
 7Igv+C+1QtAK/EUwOx6Ek7wuE6jmGZDDhexoVi7QUwrrBfyYdFUjSLEXAnEo5ig/v6w5Ox5zIuZQ7fmYQC03huacNFWbKtglfJXfgFOiUimgfenJ0ox8d/lBcwiyiko6bGXPjuQw5Lw7FcKqBBxZpyMkLSiacD7vhu+03PTjvdB3WLfPNdNZ8cb0oopoUYa9s+8EcGKnEj8H9cW3+huSwHdwvUcSracwtpkKKZz9yL5TaY//RP+WNLYYLMZmethWN7nehVXAWtYnnkwAxtdLEeFQTDrJB9qZOzhncxX+j5ZX0+7G33xlabwPIrS4Ii8qYRLiNHMZzJ20ZgEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:27:21PM +0200, Christian Brauner wrote:
> A coredump generated via the coredump socket ends up transferring
> zeroed data when a mapping contains holes. For a large process that
> maps a bunch of data that's wasting a ton of work.
> 
> Jacob ran into this and Josef has bitched^wcomplained about this to me
> before. I dislike the coredump_filter bit solution in [1] which stops
> each PT_LOAD at the last populated page.
> 
> The problem is real though. I don't think coredump_filter is where we
> need to solve this. That mask says which kinds of memory to include and
> it propagates across fork and exec, whereas what is being selected here
> is an encoding mechanism.
> 
> I also think that the usermodehelper - may it swiftly die - isn't really
> salvagable for this and it's not the future anyway. The coredump socket
> already has a handshake for stuff like this.
> 
> I always had an idea how this would look like but punted on it back
> then. So here it is.
> 
> A server that raises COREDUMP_HEADER in coredump_ack->mask doesn't get
> the coredump as a plain byte stream but as a sequence of frames. Each
> one a struct coredump_frame_header followed by what it describes. A data
> frame carries its bytes. If a server also raises COREDUMP_SPARSE, zero
> frames are sent for unpopulated mappings. They only indicate how many
> zero bytes need to be written and to not include data. Reassembling the
> frames gives back the same coredump. A debugger and everything else
> still see an ordinary core file and nothing outside the coredump server
> has to learn anything.

Hey, Christian,

I proposed pretty much this exact solution to Jacob, so thank you for
writing it :)

There are a couple of reasons we still wanted to explore the
coredump_filter solution:

1. Our core dumper application is not really prepared to run as a daemon
   that listens on a socket, having been written to be a transient
   usermode helper. But thinking about it more, maybe that's something
   we could paper over with systemd socket activation?
2. More importantly, we sometimes write core dumps to disk and sometimes
   upload them to blob storage. For the former, this approach of sending
   holes over the socket is great. For the latter, we'd now need to wrap
   the dump in some sort of container supporting sparseness that all
   consumers then need to reassemble. The coredump_filter approach
   doesn't require any changes in that pipeline.

To be transparent, I still prefer the sparse socket approach, but Jacob
has different contraints that I'd love to have addressed: it's a
trade-off of more work on the core dump server side and all of its
consumers vs. in the debug tooling side, which is mostly already there.

Thanks,
Omar

