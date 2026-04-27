Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03878FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373166B0088; Mon, 27 Apr 2026 08:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A596B008A; Mon, 27 Apr 2026 08:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2609C6B008C; Mon, 27 Apr 2026 08:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1459B6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:52:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E8081B536D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:52:05 +0000 (UTC)
X-FDA: 84704323410.10.67F63F0
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id A99C3C0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:52:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KaOy8737;
	spf=pass (imf28.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777294323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
	b=RRaoJKxhNVAw7Ruv4m3+CCBYzPpEb9aDDmgRKiCglDMmR7hhbva6GghoC2vnc0uJnUBP5v
	lTVw3M9GKTBU1o2XFWIR1wO0U3jfbFKmX7p0TzdGuBoGCRYXGuVhvVWtjjuvqE0J9C6gU0
	2NoOj+vG2cX08fkmAjwyuxOmIJcM58k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777294323; a=rsa-sha256;
	cv=pass;
	b=w236bqdNsc/HLf9lDvDWWaUgYSCeSWRLQcMmIF2w8rvn5WQLqGnCkzgADg+Pa83gaYJ/2d
	D4aCzbJETOybjk10f8uysRIxuYrJrX4eOESiMoWLBrQDvRB8XaI4c15AqthLkgVy4V5brH
	xWyRjZ7CtgvJwQpWFKKPskQ7hJoWyOk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KaOy8737;
	spf=pass (imf28.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d4be94eeacso10578380a34.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:52:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777294322; cv=none;
        d=google.com; s=arc-20240605;
        b=etxd2kUQTLMNtbyLpk18jkbktlJL5N/O6yvk9kdXbKN0AZrmfoda2ygH3M70PYJD5l
         VZlhs+FOd+WfHtrvBsDBvzJwmi0SSzvpb8DVIb3VTYojpYukNw5s8I5yRkDL/ii+t/5v
         h5KvtisN9cN6rPB5MwSzWVorlBa4arSLFtVgkpA2Fn+xDN/KDjkU+ETSnjlLf9R3O8MU
         ri3Nsg1wC/8EgC0nYH8wrNymQM2fhSt/jtlh9Xj2Pe9f1t0xv5SaelbdjBbuoIAb9lEV
         FHjSfcgSY4LXdyi3mbcJzeK27r6lPcxSo/BObJgzP2+SS+PdKK/BdqGmlvrit0aH8Jc6
         yO9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
        fh=FRgmysQQrGMySuZUD5F6OLVaOex7muwQJ6eKu1YXFfI=;
        b=hBFHNzbioI986WC/Mo2pTrEyVIxc4dzSTwq4xMCX26b2jV61I5SNFj6B0wKDwmT7Bj
         Zc43V4R4sjeP7DKKsZikDqNpK7CgWsgybXvdIV7Qh4MSggdJT+B5dZ6OsTsZClEdO/ph
         zp8NQalmWwjIN6QNsMxkqsdTqEr4hYyUjNjIOcUFb0wezfhQ03d733zOrjSzaf4EBiyu
         5/ZV+PDKac07WUUylvzc7Y4r4JCWQs4p2VkMd2HQlgGr1jdC2T9Sf2CDJf56LJmTh7Z2
         Vtyy7UI3mxlDyQ3ukVlR7e69m8efYg3IPqSJff2uRSoRVwcg4eSjsQB6x+R79qsTqvcl
         F89g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777294322; x=1777899122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
        b=KaOy8737OfFlg+itAnN12Wo755UyBi3YEdtQcpBkKtZOi57nbyu3158vWZJ9ezJAvP
         Tt816m5u3uriYU0tXmYLWEsxhHIDeObRzseLmoYXNeeXrKRQXu1Jyott1MqhqiYtmojv
         jLsZWOZTQhFVWSOtCu9ra8y8CKJZg6GigeU4Mn4lh9I4rtjEJCGSDvLoBLJ5Vb11oDxe
         6zED5Hg2eByT5+6QYA4wLLPQnF6w6a0EmyyDSAzC0dG+ynF1Gmb0drlF2wUebHzWB7ow
         xjLMWIUoI95kOFujeZoN8CQ/oWGfXSvPJ0aVdTdimj8nSGAn8AveD5S5jiuBpcRTXj4Q
         9Q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777294322; x=1777899122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EG/J4UGh3eCwSuRcJEkJEJxR7JlBLrl/6GrVtUQBlGs=;
        b=UBHSlDm2WBgsIaX5k7Fa8oWy9++1wnXOhPV8j3eD0CqvigVubnbENL2VCRrzMg04yU
         YSWRTISAO26jHHTqxunz3mLGS3CqDTIigD6gymmDk+BGN9/1D0ohXUQgts8lENreuYOv
         EiIkMqd2dAvdrw1hvzrXb4QSfdcWkFn4FDvMwA73u2ml80otpXkbQpdC7fIBjsvLyQUD
         gIy1m31KilM7tlQ3YlScbz8uLPRAe1r/xKgOf7JnO12wZALG390R04Sicd51iv/A24de
         Duo4E0VFmz7i5eO9UvyfItmhNkd8gNI0pgncekUSGXiLUkZ4k5z3BGTGKElM9P9xzTBx
         CzyA==
X-Forwarded-Encrypted: i=1; AFNElJ9V10vkDLhPwuu+ksp7pPEEfh1qscxhXdUFuAvG2ryy/6oDH624yhSCAA8r5BC1nFEw3vgOwUsmOQ==@kvack.org
X-Gm-Message-State: AOJu0YwVpB8DnKfkqbHMMKVgdSdZEfPdtd7E1cWtfEFV+NSK7J+lfESf
	FJVFe6owDeIDHLDnYcYvDiHbA4fby8qQIkuHe6t/ZE20KeTi7t3lWntGfL4NCcz8Q9BVO9oSPOp
	1ijaP4aoWL1Z2n74wBt4Ceqpcpbh6BBo=
X-Gm-Gg: AeBDieuIUhsvTgmYqOjAUqLrV2Qsd0RYJwBco8nPDzYI8YWJBla67ZAAgqaF54dAdcM
	KtsvKqPO8dd1Id5WgFgxVaAaMehLkgR2U2HfzpVJABiTprDKGaAQvOs/futM6WskJqukMr2L6t4
	jrAxzQwT0DdX/zZ6q/lWE34/1YEumQPmIFG4yyqYaRUAxjB/EuR/Xs+HDAZjY0ZYBLXeKBVoxWw
	hpk5/6g/plOgvZCQW5poBiRQCiOq+OQg9DvALHAYBr1t8+QYSKEoO6RKNGimSZtvTW6tg42xHhj
	MnlZ0ID6EbKJKYsR8c8gyt9fRPkN1R4=
X-Received: by 2002:a05:6830:6732:b0:7d7:f638:7a03 with SMTP id
 46e09a7af769-7dc950ff385mr27811030a34.10.1777294322529; Mon, 27 Apr 2026
 05:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
 <ae9ItoKFvB12Qimn@gondor.apana.org.au> <20260427-ledig-urform-4719da0a06d2@brauner>
In-Reply-To: <20260427-ledig-urform-4719da0a06d2@brauner>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Mon, 27 Apr 2026 17:51:51 +0500
X-Gm-Features: AVHnY4IScH53UaYPIaA6YOC4aKjN9vN_SqKv35Tn7RXxw0SMwzMLtQd2SMg1vdw
Message-ID: <CABXGCsPtb5dsz9tJFO-42qY4Cqd4MDg=m3g-9CshQgO00keyOA@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
To: Christian Brauner <brauner@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Thomas Graf <tgraf@suug.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com, 
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A99C3C0002
X-Stat-Signature: z4ykbwyfffqwjw8ntmpbngm6udbpaffn
X-Rspam-User: 
X-HE-Tag: 1777294323-771748
X-HE-Meta: U2FsdGVkX1/UnTQe/+RSlr7fuWtKTxASb8jrRflo+wGlF0yghgyvKbh37nBol+D+Tt+cFBxfLdFVbhJ9CQFocmhCLR36zDoWUhcK/ezEoxxPJNi7ldwaAU5tVcnrPB1NTmbwBMWid4DglJdaBUaiDcE9CLuwGu7iesgLBqQy/A6W87xeJlZvoZesoV2RPBZCRtH3NWh+DR4DXKV6Xdf0InLhTFxoJYzh/Ro6neObtezZb7C9bVYcU9i45fx7KAeNf2hQyI4uBTtjZT9lmHk5gzn/hBk/0Lv3aE1rMDQfgXs/fMPHj6Rq/1k+l07N5rIg60zTMD5EY55bmiLk/thIbnjKJ9ZgrYPDItAs/D0QPkLAarKfl8IrgXChGUaYMwlUF/S0IrAthcA71s6P8qgE2n5bS5YLSaLHIDcjvdSOYGe1Ihn+qWPjr82CL4+c6VfZQte2WYTE6kHqhQxj2SBqMlhzCSBCJQNYBe2NkC6suqOqg70Q0X5eZ9TLTTmNvDHza5Zj4CfYWRYPhlxI1KoT16HwbD7yAq0XNsd1kV18JNrJFLu282B25AcVKL8N0Amk3087Cgjr26EaGgusf/b1WabuFC547dWMpETDrjEz/BXAI6Mw4rB7BDQj7NF5rnGuP7RdPrsB6IDDI7iHnQSQYUxj4MYBG4TMnzDBPRHl9D5q2RDQ44E5K6M2d2s11v1xofCJNsoPeUjAyepvIvx9xl3dTSYQCBpEJttkWJN5a5SoGj4OP29VbYeFkNzlZGm7F1ZiqKNNMHJvaLKQGgfi6xAC3rj/JKWx7+BmQxC6X0km4iIMo5NoWlRBSSy9hUCAevCj7zyBe8Vb/ghuDXNACc2uK/2uIrpkYrOCXmulTdtli0L9+8/2YRhu3A/SsjmBUZEIqMgJWbsMwNwjipT2nUkDH+LZD+sLIPwYCl6veq0Ijv0apuloxVv0aW3ds4FBjWmsdH2Csb6r7S6kq1U
 HbTbyEG4
 yvhrRkiDK2VIkFgzlHQuoRkYA/ErT7AgCkdmGEtaKtfrHK0n07hA2mDDSzWUG3mbbDohUSkViyL0B9tc0HRZmbhjEXNzFBLLQPT0fKwT7CmnwjVukoZYirIAccdB+6O8jOvoepi9RDhfshi5HNs7cYlZaimMfCc9JyIjOoiNFyk2tt1aA/9tuslS7xy6aJc2qRsG4HOGvDVGOFqDCxDVKID8XJ3okFbJlGd8EU6ypQH9tcLFcYeAW4fhGYFIz6kRlOCfUFhgV7oOn+0M/tOfoFXy8EwhoVlb7llml9Acm+GZqNnWzoBO9QpS1D/yStseIRccOsBvp4l6THUK955zxDUN7HYbL4eg39nt/kYRkn3E13Dkz7+pKktO4kSQb5Onm0B98ObPb4PWWX3VIMAbf4gLVb4DXv/quHyK/CLtqwqln8o8Nw6eG2zI3dbCjCoj2zDGsbCw5l7lBN04nmpZYbj70uxEpuxqHlKVdLnSHkjCll7NNqnfW0j1wAornw7WPnwHZeRPtyP6JfH4eyZu+3SgL7GSYbe4jJrGZongGQpnUBPn925Lcfn/2xvuHYmo96onEi8ifPyctQBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 5:21=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> >
> > But could you please try this patch and see if it also fixes
> > your problem?
> >
> > https://patchwork.kernel.org/project/linux-crypto/patch/20260422213349.=
1345098-2-mikhail.v.gavrilov@gmail.com/
>
> Possibly, I don't have a way to easily reproduce this though.
> Imho, the right thing would be to have both: actual useful keyed lockdep
> annotation and - if safe - dropping the mutex.

Agreed -- the two changes are orthogonal: yours fixes the lockdep
class collapse, mine removes a mutex acquisition that has been
unnecessary since cancel_work_sync() was added in front of it.

On the safety of dropping the mutex: rhashtable_free_and_destroy()'s
documented contract already requires the caller to ensure no
concurrent operations, and cancel_work_sync(&ht->run_work) at the
top of the function quiesces the only in-library writer (the rehash
worker). After that, the tables are owned exclusively by this
function. The walks I switch from rht_dereference() to
rcu_dereference_raw() were already correct; the lockdep annotation
was just asking for a lock that no longer needs to be held.

I checked all in-tree callers of rhashtable_free_and_destroy() (and
of rhashtable_destroy(), which inlines the same teardown) for
correctness against the contract; none rely on the mutex for
serialization with anything other than the rehash worker.

I have no objection to either patch order. Happy to rebase mine on
top of yours, or for it to go in independently via Herbert's tree
once yours is merged.

--=20
Thanks,
Mikhail

