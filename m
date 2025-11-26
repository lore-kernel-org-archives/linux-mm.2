Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AEE7D1039B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 17:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA74F6B0098; Wed, 26 Nov 2025 12:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7EF86B0099; Wed, 26 Nov 2025 12:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C950A6B009B; Wed, 26 Nov 2025 12:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B73546B0098
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:58:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 402CBBA77D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:58:54 +0000 (UTC)
X-FDA: 84153518988.11.C07002A
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 649471C0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:58:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaNPXe58;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764179932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lTJ8r8pPFEaE7EZ8M4aIH0/lzPnxcj7KdKFi6y0z3M=;
	b=hbJmoDcVSQHDiXpaAMCFwhkOd+endV5HmSRQKPSgptDF7A/k6FyirThCb9WzeZc4KOiXxN
	0D7Wr4eqaFSugN5ACVE0ikS47aaFM53DeaViRCCUUdgq01otRq+XlmCHYNofzOrlxAteL1
	N2L5E44jz+yUC/dAPFWgJE5sQcn9zkU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaNPXe58;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764179932; a=rsa-sha256;
	cv=none;
	b=ll+/rZlEeRCQmMd2YlCenHBCuV0QgMwqkpV0g96YmiUYufoKQWDxgk0I0ErQeV4Yz5NcVo
	qSa3TM9+kphpWUM/3RK0NxNN8/cdq+lu5DgxBjM0jAUjZREJuCevT2C8GLHQu9Wbm8XQgL
	NNkvI/yGXduLsl/x08bH12NMw6ht1go=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee2293e6a2so1070921cf.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764179931; x=1764784731; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lTJ8r8pPFEaE7EZ8M4aIH0/lzPnxcj7KdKFi6y0z3M=;
        b=eaNPXe58H6jX+Z4QfzPXA02JNLBL7bYvh+U4J1z0v3jCiaTZ/6AjsO9yg9PSs4d3zW
         Rsl+Ypg65UC8tqOzpMnz8fD26shg3Ny563RNB9VuHIOxMDhwGwb643edQmv5gJnuTu8R
         Wrph+V+eLli9VrljskC2WqJsOFtbhLjQAtL3jXBH07JD35GQM5QxFtbzzLIZtyAr9wiK
         cWHyNyzrcXm0i4BFI37LgdSwl2GoBTJlvuToN6KYdehati2UIehQa9pEK/wnggShOVJy
         5go40jX3dsgA3gCcx2L5sQWPGbRAnm//RYwIiLw7SOX0UZBrX0s1/4TOd4FYB7NF15QH
         sPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764179931; x=1764784731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5lTJ8r8pPFEaE7EZ8M4aIH0/lzPnxcj7KdKFi6y0z3M=;
        b=BAWSfSnobb58ElkoR9ygwzyX3Ngw3km5v5UCVa7/ba6PjBD/CRmf7F/q3DxmURAVTg
         4n0v6Vh6drpMG2pFrKWyH1BSdgmdCJwzdVLqTO5V6NYcGcxEcyx8SkwWc46TsVgWDHQR
         gT17PjL+QiB1EqY4QCYdGbb0L5iElEI5sPj1MjxzXCIzNNoUdMIeiPy+fd/EDCIVJnsS
         zX7lpsla8ryu1dFanfdXHCE600myMdKKkX31ajbW1cQg7ITA4BinD1ncG6vfTYqO8vGt
         TCcLVVEDbxcBU9cX0ZIFikwQYpSlvPpdf4S+s/I7u/YbMWeV/FvWK3UJpoVcvi+otNqj
         rFPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDYjGjv+RV20iZftP/sZ858xWGNQYW0N+vq/r3Pksqf08WnZkCn0YxaQahtWKLldkFR4E0kaZzpQ==@kvack.org
X-Gm-Message-State: AOJu0YzoylSRvPOB4pYQkKYhZaLK96j7DLzqlh03FoYkpN88iqSGZmWa
	lG8wEQ88025tWz1vfG81eJ1JhBkir1SjGOZnLe5PrJM81eL96RZOtdUxbOh9SgIFeyKJ4mMdgOV
	Yvn4oW7mp09chmKbVLWOwBQmgXDuaRH4=
X-Gm-Gg: ASbGncsHmWfGaPNK1gFjp8OkqU9An0I9P9UqmwC2PpNI6zsHyt6B5MlluR2GpvpTw0w
	A4frBHcst1cy61gowlti0R8LPuW3QlOoUb1dE2EhWTWRB6Z8don7985NjlXpdt6Xm9i7Z430lqF
	+RQXy2DHLTr4S5+EwE5iDOsICDxkroYJV3MRJQI3innd2bJBqsBXjCBYvLIMm78+e5yQjj4kNEI
	zaALf5g+EKxT0tLXCR7ZMR+d51wODb8t+OYK1fXCC4FQzFmI/qFvfgIofQ42l+cCGTPhw==
X-Google-Smtp-Source: AGHT+IGUMPFl2u4LYkvi5XrfvZZxNf0T7IQ/UmH+m/1OY7Kuxsj34G3KeI/hNPM04GPlwQrdLOPhH+phTrJRXqJlY6k=
X-Received: by 2002:ac8:5f48:0:b0:4ee:1a54:d2bd with SMTP id
 d75a77b69052e-4ee58ab003cmr287861791cf.29.1764179931447; Wed, 26 Nov 2025
 09:58:51 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com> <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
 <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org> <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
 <504d100d-b8f3-475b-b575-3adfd17627b5@kernel.org>
In-Reply-To: <504d100d-b8f3-475b-b575-3adfd17627b5@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 26 Nov 2025 09:58:40 -0800
X-Gm-Features: AWmQ_bnpX_M54rPqypc5h1eZeZ6yR9KrguhyZF92GnYk549xbCVZ2NRiunLmtEI
Message-ID: <CAJnrk1a1XsA9u1W-b4GLcyFXvZP41z7kWbJsdnEh7khcoco==A@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev, 
	athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 649471C0010
X-Stat-Signature: hbr145qbcup7js9t11qqxo6fctxqdcrx
X-Rspam-User: 
X-HE-Tag: 1764179932-810063
X-HE-Meta: U2FsdGVkX19sq9grp5ncTMPpOcKeylz9R7j/rrzmsWOt+GIdKw+ObOxxOOVu8BgtZEm71APHFVxeguoDMEKHMXq794WULLQXE7REqKxhSn32alwx6KlIK/krCJxmeoqHlvUuL4XsEdLnFtCYZ8zNWdnI/9eXWpQmrBY3b7XTmYOYDQPwM70/oaNkxd5CG165SN0dkdzn85Ac68e3GgZSMUniMIJUnic3nmBJIgBiiGx5V6AAzN2BTNgonBanboRY5nJpjqInA9MUqGbWpdTHofeWvrG95WRIqVCn9BQGzez48t0H/UhLQOCXFjKIpDcalx/wFaiAo0vuyF4Fxzga9ycn37B5STP29zPRuISJQTxPvWgjJnyyNW3YA7KOHaMLazNrjisXk/rDTjmA4dMjhM9pvK79FrJFJ64ozNO8xPfLrium41eyfm/IEHtvUE12+aBZkZleROzOyEoxdKqcEPUiJqSboV6YKx3AWGFn31F+HvLfk2S6wYo4eQJ3am1DOeukhu9C+ZH630YLBjHpRo02oyfhudaf9qa35GeP6Z1iK/zOetkeI5XaPnClRKhP98/ymnvgx+qZQuRXkCz45jnxUYjZtRr3e+Eajg5ITDhcY3IDGiCZUiUdS9+FEi2NKaUHD9d9dhXfn2ICS5mPQhYsK6Y8aCTPeu82giCrOv/xox1O7d1IHgkwzmGDpJcWHmQjx51Aiedvpd9Ce4MlfP348fNl9vZcicHexORO+f4raE+L/69hl2taGjBDyd3nVcf1VacIiuECk2o9JRLZIGpAaBzMjmzibrYrBej1ncc9xAjQN9gUOyoUPZFLyolGhrjNUXMl18yoPzanGoXkS2dXeqH2NkevDUvA1WNNXs8qOksB2bYUhVRJTeFiUC2Kr2cnXMhXBntpIdiHG5zVWpxqYyxPa+GeBXLSfyc4Yk7/6fW/juCos8ezUHzjsK/F0lriiRXEgFHRHNaSYyO
 /I+XpKdL
 Kx7KjwVbcT/fZyqnE7eyzPuUTR7tjpqJKE3MkGzaDlnsdSnwdSyoQQGzqd3Ui6ZbP6XxJQ2xLRBF0vp0rkTjTYbMIEF6klj/gj8lH0FHps1iHv6JO0Gv3m6JaXRE6fYFhCX8rtd16L+eoiExQqwvdLq7ZHKhFD1RnHJQLzKDf5o/W7kqbnTBJi3fwFIx7YmSAZJCIy5UpLzeYBHJwDgC2HJxFwkdzXfn+wYb2FjqTcR/b3xS7Je4HqkMza0ECJgMbnJMxH35TF06W1JqUzdN/LXPXtr8mlH4hWCr9e475MFQfZ5cNkCTza+ShR6QBJYBKkqX9okp+kInS+Q7j4hJkiIfpP2NW/ZLiMDhaL+HNPJ4WsGfR8NDI7LdfPaziY7G/ey7ZBVwwOuwZWbloi2DM0xrlgX/xq0xbf1Ol2nJGW7abqgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 2:55=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
> >
> >> having a flag that states something like that that
> >> "AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC" would probable be what we would wa=
nt
> >> to add to avoid waiting for writeback with clear semantics why it is o=
k
> >> in that specific scenario.
> >
> > Having a separate AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC mapping flag
> > sounds reasonable to me and I agree is more clearer semantically.
>
> Good. Then it's clear that we are not waiting because writeback is
> shaky, but because even if it would be working, because we don't have to
> because there are no such guarantees.
>
> Maybe
>
> AS_NO_DATA_INTEGRITY
>
> or similar would be cleaner, I'll have to leave that to you and Miklos
> to decide what exactly the semantics are that fuse currently doesn't
> provide.

After reading Miklos's reply, I must have misunderstood this then - my
understanding was that the reason we couldn't guarantee data integrity
in fuse was because of the temp pages design where checking the
writeback flag on the real folio doesn't reflect writeback state, but
that removing the temp pages and using the real folio now does
guarantee this. But it seems like it's not as simple as that and
there's no data integrity guarantees for other reasons.

Changing this to AS_NO_DATA_INTEGRITY sounds good to me, if that
sounds good to Miklos as well. Or do you have another preference,
Miklos?

Thanks,
Joanne
>
>
> --
> Cheers
>
> David

