Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A51C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 18:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127006B007B; Wed, 30 Jul 2025 14:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7D56B0088; Wed, 30 Jul 2025 14:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0155A6B0089; Wed, 30 Jul 2025 14:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E77926B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:42:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 725F5807AF
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:42:44 +0000 (UTC)
X-FDA: 83721802248.02.EF788FA
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F44914000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:42:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=agat7lpz;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753900962; a=rsa-sha256;
	cv=none;
	b=rExluKxLwbm4EGqeG+aPacQZmU3uGDd15AkblMnmVUcWn3ZLNRzVVC3jGO1Xv1sLcQLgT4
	bN8bP0n1G+Y1vfWkkJa/pExsGfSIq0zg0q/uXD/PbqUWKiDtJlmUGu2hQvOZJv2gdcjQd3
	Z3b6TbQkODzVA8vaxTwq4by8nJGpUow=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=agat7lpz;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753900962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/8KJCdai8KrtDfwinWM/LaJFRv4FrevPGL+R/XtgR8=;
	b=nrrvloHbS64A0bE8g7m50iJytMHlFbxkLjRlTe8UAHySgiWpZBnodAJAzaL2pbyCFwVJDl
	V8ifedONYBmKA8KX/h7TfRt4JEZ7BVOu2R8cyDo4yXF8BXfhUHZAFFmap92r/r5681+q39
	kO48B2aLOiHefR6e0Z2loYrobBiM194=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ae35f36da9dso23824166b.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1753900960; x=1754505760; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e/8KJCdai8KrtDfwinWM/LaJFRv4FrevPGL+R/XtgR8=;
        b=agat7lpz5YThvJ4i+Bd8UDs7x/v/dWOLHVp5fAfJxW5Dc7LNcp2woMIZCBLCkNRvnC
         op0PHfjFjO3g2uKjU7/CfZC2MrUEmmkRMtp5g1pqyfFYohuAcRXWJzRlpSoiQNKuLmij
         UMz57vLBOlHVhYMlP5uKL4UT7nhYfiltGdZDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753900960; x=1754505760;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e/8KJCdai8KrtDfwinWM/LaJFRv4FrevPGL+R/XtgR8=;
        b=doQsLIxRcyOCN7Dq+ngR++N6MIutFCW7DaoGhNLu7XrstyaUSHyaE+Ui+QICwAfAIT
         p6pODh/VJo8HO6nCSUtdq4EOpW90w8aSFn7jGzPwxHWXhkFXQXFlVbdpcdv0DDe7c93a
         B7SeYEbBbRXomvVS81OOWG68Xb5/JNTGj3ZIR2eBt9guK671JeayprxBnS6DbR0N/+61
         IszlSm5U5ygc1gcGpIG0LlXtXbFlOObykFXxFmcy6LxILIKgkE6bK/BevEkJSpNtJu7K
         wPUj0J8S6Bkqj3H6dDeyQLLNMQyCT/hj/AMYwn6HyfoRDEULuadv35jPeAx/MelKZvB+
         PK0w==
X-Forwarded-Encrypted: i=1; AJvYcCUneSxigmn2GxGdyYJMA8HUgBHdSr666sYX7mTpTC3Z7ORfuTz7xnOKHiC2uwlaJ4Luawu2B3tZlg==@kvack.org
X-Gm-Message-State: AOJu0YyDI/kg0eXh7RafnkY/0BShJQ9s5+mxlUvSOoMrZIPzpygwm6AI
	svwr4zbfe9ipiLKbxzIJThSpr12J1vozXdxCtNQmOUSMtzcMRokuc/ibtgx0yGGOAKa+cwNoHLG
	Wz4OymcE=
X-Gm-Gg: ASbGnctv6FmfFHO4DExAbqt9iZc01hONXyjTVKVGxFIpwmHni/gk/ciy3QNCgGRJgKa
	tuNtTBMzUk9zAr2KM27NLdIW88PE0SsakyqlOAALZ3IqEWddORyeCeUK0E6bFIVuE7mXG5TPbmE
	qOgxK0nNtqc2yQtOdT5sgs+sQI8djq/Sr4/hOrQuGpFsZtFCcF6xTXpqNEG4LAbjNC9hqE6SR/V
	ffKlKAxCZYEOXqrHSkDI52Z7FlfK05RqsyQfoBjWYerfIMjWtMEE9HmCZY8ZOuL7jNGEJdH8MjZ
	WhDY7hhBR40gOx2ap15ELQEzO5W3PQROUYLJ5r7FdrsUbtBKSp/i+dQxxZXEFbjNnnKNfoZyw/C
	ynRUuU8/SVI/kjaaayNyyZFPVLITXM/EIfIhLjhFgqt+KC/3oXajCpr8BoQGL+4LB156B1Rp5G4
	2V7r0QUxU=
X-Google-Smtp-Source: AGHT+IGFO+Vf2+ivAPQfU7GHdl/mHHj3LAL25dkxQY28hY8IycyNILt0xyKriIEaC7mS16vFcmUztg==
X-Received: by 2002:a17:907:6d11:b0:af6:a10a:d795 with SMTP id a640c23a62f3a-af8fda59afamr599030966b.55.1753900960222;
        Wed, 30 Jul 2025 11:42:40 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af6358a1aacsm783503066b.49.2025.07.30.11.42.38
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 11:42:38 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6154655c8aeso90687a12.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:42:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVrBKxwUVZYo50FBQ66g8pHmKa2WSY64gOMPmt1NxVESDx9bUV9YdooiCpw96m7H81LFM2gFChV+Q==@kvack.org
X-Received: by 2002:a50:8745:0:b0:607:5987:5b90 with SMTP id
 4fb4d7f45d1cf-61586f12581mr2997178a12.11.1753900958279; Wed, 30 Jul 2025
 11:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
In-Reply-To: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Jul 2025 11:42:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg70=mihHE3_Te=t1Fmvrh22bcEs8bvH3tDEXZd6q+4_g@mail.gmail.com>
X-Gm-Features: Ac12FXyIEgB8PrPgd0exea9RuFqBlTLaxSkR6vauSlGJKXBn_YJf0vKGTRlMTV0
Message-ID: <CAHk-=wg70=mihHE3_Te=t1Fmvrh22bcEs8bvH3tDEXZd6q+4_g@mail.gmail.com>
Subject: Re: [GIT PULL] slab updates for 6.17
To: Vlastimil Babka <vbabka@suse.cz>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, 
	David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Pedro Falcato <pfalcato@suse.de>, Bernard Metzler <bernard.metzler@linux.dev>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F44914000C
X-Stat-Signature: 675ezemyabaw9kothtfu8mj4jt16fmjs
X-HE-Tag: 1753900961-253725
X-HE-Meta: U2FsdGVkX1/TfPCOpKE7/Iqq7ZtmrnXsY92qHzrCGqGZoHSXDWh1++5aNy+uyLDNQDOHOP4QIRAF4iK5FODp8tUA3mKY/AFjBv+UWywe8AYFNv/rcVkMLdJQMckOYrm7R/wmomlzwSDVFzVTt06/mQLYxt4MbbruEFmuHfCRVGvtjajQwsSDCxjthQEYpp5dLKa11IcXwf9a9gDMgUYf+t+i0vJQYsPdgYnvMbIlELz2UOiztNY0cRtsX0OoVpHlIddlldA6Pjeu1oAkSLK3+7KlBmBXcO9BTXmcZCoMRmTa4DQ3LMFceq28SJN7e7cw2YHtfz6FPYqr/SqPEs4f02jZsZOIY7XZNFy7ia9O0EIIEmC+8NydicZtenBjcstlNCVmflZ/zr+asxYH2pyzPBOFj0Ee4sBaPNN0/zBbpLouCmkJFNQoBp4s9xcN0U4qbir3tKuwTUEk+xqfukkXYRwBSG94t6ksXx1Sa2T06bIfIlad/0n6V5JNIjUs6nU6Ugy2mDJZ4L8nQ0vWJFM7buJQFZPYNUG9qRrPKlIUcFe8FBuzpEju/3X6mcUq6TMsNKMA9r9vU2mkV8Q0I7cByWz7wUrh4J6Wd8kkxVvwnUGWXMzxxDeKr1eAAAgbREWfSeaHNXPshvSP2pDz8vhtH1sE7DZX5oVDBBLQFKlIwxm+9iLrXUsTSeurmQ7ID3dYP5zORwdwgZgmq9Fxqz3aYs4/gU/rX31Rs8DF/VO8HCjE9mogGkTq8TxEI3HbSBziC42i2Up0FJLS5RyFENgy67OfnlW65yRuVuG9X+XhDOxjDodR6a5WUjyZBNvo7uZto1qCpyzJ9fCt36a+vKc+Uj+pNRJyCDRY8M74mrKEdi7pkliXJHg6FCnwlAbatw4WDENq2m58nXWyLDRk1UofE/ucS+O4OG0WJO/dnibr29B1ApHitDe5Uh2C9MiY7yz16C+t48+mBgbDEwfA9M3
 0hH2EZzd
 pVXkTtZyLsCMV1ziMBgH9LLrtGuDXLPnEMr6gjtbcPX5DFI/gxCsgwtL31P56gl0a0GIw6xfZjM4gVgzaSAQtVJEgDNGHKkM0Qo/sg89CCtDN7VyveoJcqWexEjb7AovSeUdvLj2N4MibiOzbJFihWlLi9CuTWdf+fBt+YGi57w8d/ths7MSHcxBgKn6OZX0rn0XYZNr0WPz26ELbme/qB2Eul7OGPCoTy280Iia+qeJcp9KexFJuUaHlWRa5NecB/wWPnKN9BW2YKOI1zvMes3t29coniN1jdhnsJBVrkzTp1L5LuFpmobc+5nHYVR+liAjOrb+gnpGr4BqMxKHpmUx33zGAlRmCWzkDXQRYIU9yUc68B59KGGHWXLYxoDVBdorg4lvwcWxeSZfuR08DoZDyMz7i44ojYVThxmqqAUuBCY+V4jrE5MZE0N6uMm9oTkGjhYDzkJvSuVwI1DA6ugwfzt5MiY1eFF8nQbPRVhS9+qg6raZb1zTXad3NQBZ2ypcsmUI5rkmhoW3XndstF0t+jbIbFyiEtDx4gd8OjX4YXkkBDVtllflEVZ9hmHC2+hdS8zhPomgfM5jcYnc+aqFSwfuvNb5q8zL6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 at 09:56, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> We've hit a last-minute snag last week when lkp reported [1] the commit
> "mm, slab: use frozen pages for large kmalloc" exposed a pre-existing bug
> in siw_tcp_sendpages(). Pedro has been fixing it [2] so hopefully that will
> result in a PR soon, which you can pull before this one - or perhaps take
> the fix directly. If that gets stuck for some reason and taking the fix
> later would be unacceptable, I can do another PR with my commit taken out.
>
> [1] https://lore.kernel.org/all/202507220801.50a7210-lkp@intel.com/
> [2] https://lore.kernel.org/all/20250723104123.190518-1-pfalcato@suse.de/

Thanks for the heads up.

I've pulled this, although I don't see the rdma fix in the rdma tree
(the pull for which is still pending in my inbox - I've merged a big
chunk already, people have been very good about sending their pulls
early - thanks)

Let's hope that gets handled soonish - but I'm adding Jason explicitly
to the cc just so that he sees this.

I'll take the fix directly in the worst case, but prefer for things to
go through the normal subsystem maintainer if at all possible, and
this one seems fairly straightforward.

             Linus

