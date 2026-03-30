Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9F81061B0A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB7D6B0095; Mon, 30 Mar 2026 11:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9831D6B0096; Mon, 30 Mar 2026 11:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899446B0098; Mon, 30 Mar 2026 11:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7416B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:31:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A3D71A05BC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:31:33 +0000 (UTC)
X-FDA: 84603118866.01.BD79FFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB46E180011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:31:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UllOtCx3;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774884691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGoi2KMPKpxvC5dFHJDLri0kSNHANukE6bgdOzbv8OI=;
	b=0OQ5QMkJO1VjvG47HilpgCWHN0Az6AEuc7iiro705UEHf0gOSTKZbnss0vZc7KoOAc1fwM
	6TMpI7awKR75sOeDU+ZKrC80euxDJSK6CwLnGp3tCzDEmkNjIg1cWokKLrbeNSvc/tbl2M
	RuSOhjUnnDTljGak54oWS4jq3sASGig=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UllOtCx3;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774884691; a=rsa-sha256;
	cv=none;
	b=l2Ep8q1JFOsI34+AoMLxcahn2YbaIoQcesyyxntGTKde+7Qzgbip7lMZ6g8mfznZNYKBfR
	WN48aeja/LBml07Q3lGumCwvkAd7GTtpGRmOG1kwZRWubx7SQyOMirNF1rASypNyCMLaU6
	fPMJRTLIMRLdhwn3UmBPd2Lfj4ByzgE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774884690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sGoi2KMPKpxvC5dFHJDLri0kSNHANukE6bgdOzbv8OI=;
	b=UllOtCx3a4jh+Gt1KsocR62a17J68XEFQ2nDkVirH3GOsEmtoCSl7/3MiYPxcx4CunEafD
	phwG3NNeZPzr4OsTdEhTx1SNxQClfbLTGdfSJ86vSy0HLHNTLPu5p2Ov8lr33FnCG/GoUG
	+NVycMvRAy7zoRls8o/EDJrZD4pm+GM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-37dnQzKmOdy4eLzTv8zrHg-1; Mon, 30 Mar 2026 11:31:27 -0400
X-MC-Unique: 37dnQzKmOdy4eLzTv8zrHg-1
X-Mimecast-MFC-AGG-ID: 37dnQzKmOdy4eLzTv8zrHg_1774884687
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cd849cd562so1275096585a.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774884687; x=1775489487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sGoi2KMPKpxvC5dFHJDLri0kSNHANukE6bgdOzbv8OI=;
        b=Dl7OqaykhGj31kGChMQHJPckVlKMNUCv18w4R+bmvjajlvSngLNOVse/H9O3QaxJHc
         48YDq5PaJRdqFPCSXEirUgIBdkjIfgOJYn+tdtpuZOCWOVeylIn7fNlhXQVF+u8xmSy7
         sFXv/XmJgZUYJrn+IMbQ5vQSbLrqf1Kg3j70qhKzn0B9hAIbasMYaQCgbuILLPSRUm5L
         CueK2vKNo+7uvh6xiC6g3S+x6UQnzIEG0xQiDekhK9+xeyb3PUIZhvQjCF0fcwZkt6+N
         1eqFO5xN9+MPI6RUerjpXD9uxmlCOjFpYhxNBy6C3vhcLCmb6uk8yEvD4TJ20V6JrYy9
         /Vnw==
X-Forwarded-Encrypted: i=1; AJvYcCX8mY4PykC9+46wYOVS8/aB6JrPPCNzVIn/qRp3+sG9+9eFYW8drMWkTuW/jDslpq8adTMTeULT5A==@kvack.org
X-Gm-Message-State: AOJu0YxYk9dq0iT9uP9escdsIqNnf2i7/yAcIwWrucF0VqLdw4PbqRVY
	VFEtkqJEpzyXyPSWGXfj6VJPMy+xWZU5kavO1fsgNk2K8MPveWXUYip5P0P9BBUoROV/OYilxIe
	XXeuc74gZHCjh9mZOplKYKTbMFOBXGLQE3ZIdtGARC8eFRq5l2wc=
X-Gm-Gg: ATEYQzyuKDTgPXLfkmQoqEMfV5Y2vodSiOu4+TCK95ahE7+s1XBcxBKrPEDXNSW1cxm
	grFYlQ8A0/QEMmoXHBTS0ZEnXY6MWB7VjMjevDw95UAcUEKle+c8hhN70+I8BpB4vC1yhCAEaaa
	7+HlD1Cc5yjNqepqErF4+0v1SiXey+7cWea1zhdyaIzjAnJH6ka2AJ4c17M6rLSbYrRgMdd6TiS
	lmJAzCv7I7BXmRQV2AbwqPzENG363v38WXPTjdy+aicZg/Y7tq/PHU7/0lKgYsYJW7HZnMpvtVO
	tFUvOhH0VXQLjW9a1BqQ3WR0Andsc6oFssYRlQC6IOOSMToEncnitzGRGXh6nriZBlXfLheHJ/Z
	77ppbBiwc3x3dQP7FcwlONMbFfcKBhtJ2ll2WGi5wkHnXOG8=
X-Received: by 2002:a05:620a:2911:b0:8cd:c03d:b6db with SMTP id af79cd13be357-8d01c8253b7mr1601952785a.52.1774884687209;
        Mon, 30 Mar 2026 08:31:27 -0700 (PDT)
X-Received: by 2002:a05:620a:2911:b0:8cd:c03d:b6db with SMTP id af79cd13be357-8d01c8253b7mr1601945285a.52.1774884686516;
        Mon, 30 Mar 2026 08:31:26 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d028041852sm623948185a.30.2026.03.30.08.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 08:31:24 -0700 (PDT)
Message-ID: <8cb2493e-d61e-40d7-8e39-762032f6cefa@redhat.com>
Date: Mon, 30 Mar 2026 18:31:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] mm:/Kconfig changes for migrate on fault for
 device pages
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260330115611.347988-1-mpenttil@redhat.com>
 <20260330115611.347988-2-mpenttil@redhat.com>
 <e2933d9d-1607-4be1-9868-e15dc7376106@kernel.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <e2933d9d-1607-4be1-9868-e15dc7376106@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x3HtQebcVM-HNRCX4YtSHHoWr7FlSwjSIBWEATW5RCA_1774884687
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB46E180011
X-Stat-Signature: cwsips8p3cm7dkpbxdqrdd86jijbmgbf
X-Rspam-User: 
X-HE-Tag: 1774884690-917
X-HE-Meta: U2FsdGVkX18PflGvYjcjiHCnUjzZfw6RiTnsC4QvgyopEchPmaLblO8PDcnTPmOhepg5RAR4LNe9rMcO9mrB0jzI1nq/oZ4HojSshht1m7n9h5LHAM0By7IN++ilukICOUWruKlpP78AIzvUX83/h1oUfxZ7jL+4wZybbp2MlW1lzL3YF9TD44C/KCe3s0bkO+Jr2eUX47RbPZAUEn/rxopqo/ApllIQpWnjkVYUhIEi0OThj7ffeAqwnlBAepobZ/zL4Ywdv07UuzTbVc/hxDSjJu+AEVrOkhyyZvexnaUsefkhrLGAF40hFHAB6bJRX86cqD52eKv3QGF6OTYZ0yLj/dedlA4ZVxC5L2xG+8mR6AxBVBHkZV80nChWpdiIN82qBFwgBE2xmxR9tKNlz/6fZVEEC54pAE4SAHfr2zr+zCddeyOxdui47hOa3LJX4jkmmvGLv7CcPgXgDS9MlQKpADlcfGbc6UNjsJ+XWS0I4Uu5b7G33ryoAWcPVhP7tG5ThxNz+jONGqacmMFd49vp5iO7vhhJ6iotaruNM9TPNIyq4xYd7YyOTCGGJeA0UlLoxzlfM7VfTcEelwH9g2Ewww8LlEEvHIZGT2geEUVyMJpV0jt+Yk/e5T793pEKC1ic+fLSuE+7NRteOtJoQ8RCtYQ+BXcbps5lo/Ngtym77rGME2B8OZkwY1t/AEhO3GOA2NpcTwJvWcufgENoCBmzwXRkl25wGIic8tTu9XiuqUwmeIZ0BKFSb1yQqTEBEQNha3gicriyrgbusXox/odfuQry0AtRyiJKS+LvfyU2+1GY1St4KrflyAGs6RBhYlQ36ZbZHpcRqcqbwuajl3WasrKz5Y/snDs29txrvYC5K7K8WP+SA3XkNgYoZdnvn7SkrcGEjxEgdr5fmCUcaLtMuI/CrU0fmsv5a8gZj2QYiNR/wM5N5WqVt84InNNz2oIWYVB7hVAPBDwvGJa
 pw8h4ZO/
 9ftIZWSXOq7UzftW9PLt2x/ufqi/H1c/0xXZ5gcvIA7ufRe35sCR3giv/d5KiEYNPSNnhrZtFFM0DdQBpLigTPlLi8pizP6Rle/bmd/XTc9Kd7v7DwEkx92kF9H3PMfbDVAzqIeeBUHYkcorPHA0vEOduD2evRyAOPwo+qNC0edw7qgfrCzjVDqbsHtFwUEf7sCXUSYRTARBEDuuh20xfxNdO5qRke8TSbxobBEW3hmKDqhUuIIHPk2GdjwFUtVllqGJ4pcN/FexBiOqcKxvbUEnTi4foKNj0P2pz/Y0KAbrn4mwDjwKxVAGJ2tCzmpDOwAFS2pBtwBZIJQcdLmDQJ+KlD0jq5R9OCP+ZqUK94UorevhF7Vao9+BrHFvEcvZlTqRT7yBYP7Zdb2K0UltqCVFiFsmf80KJ+21ne1sAqHRa7dy1vK4849Q7e4CaXPNJEEQ8+jq6qPdL6t28KW/e+eA0JkwqjnLxvChnQGd8elNOXYHjSHdzHOEbT1F3P2qUpbL8SutIxKw11irODkgtCH35XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 3/30/26 18:08, David Hildenbrand (Arm) wrote:

> On 3/30/26 13:56, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
> Hi Mika,
>
> nit: subject should be "mm/Kconfig:". It's also wrong on patch #6.

Ah yes will change..

>
> But more general:
>
> 1) I have two v7 submissions in my inbox. Which one is the right one?

Sorry about that..had a merge glitch so did a resend, this is the right one:
https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/

>
> 2) I don't receive cover letters for the series. Please make sure that
> you CC everybody on the cover letter.

Yes I seem to have lost my CC section in couple past series.

>
> I recommend "b4 prep" + "b4 send" for patch series management, that can
> simplify both steps.
>
> Regarding 2), if you prefer to do this manually, you best put all CC's
> in the cover letter, specifying "--cc-cover" for git send-email.
>
> This is also what "b4 prep --auto-to-cc" + "b4 send" will end up doing :)
>
Thanks!

--Mika


