Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55946606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IxQoOkAp
Received: by kanga.kvack.org (Postfix)
	id 6466E6B0741; Thu, 19 Nov 2026 23:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DC36B075E; Thu, 19 Nov 2026 23:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C1D6B075F; Thu, 19 Nov 2026 23:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 354606B0741
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:21:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3A16A0D41
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:21:29 +0000 (UTC)
X-FDA: 85454198298.23.7E992D1
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id CDC6040003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:21:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IxQoOkAp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of sendavianemail@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=sendavianemail@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795148487;
	b=Ksq/0AxCKGvz1hfj/8q7ONEHLdBTJ6XaUsJI2JWIbLYNXqOleAdp1l05TBiZvAtc0DpaBW
	mU8Y6NL697rLwrZeDxOlYEJx6aXxDfby5qmJSOwZnHFtrY7qYU3W6jW2W08SRsE8HWLpOv
	Q95Y2Zvf80lQ1E2lO60IlsHzcfzWdHY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZofWyob445pWeNhb7OktaRwpuZ/DPW8FberUsxg9WQ=;
	b=J8PTKKJ8hnCIW7hERGX6ZANbU0/SqUSidji5bCAfEFyw1iOtWH050ksrASeh5wi8fOMg0i
	dWa6Uad/I+eIn+qjYbq1zMVrVUyAh08x1OQZLq4DexcGrtav/dZJLA4xo6qNf462/r7/iM
	UYaztX/gysKegX53UHZjKJQl5+9rhfE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IxQoOkAp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of sendavianemail@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=sendavianemail@gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-67be4f2f4d4so642358d50.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:21:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795148487; cv=none;
        d=google.com; s=arc-20260327;
        b=mcfSKZming+FbQuIP5QAXUzfpa8lWmkKiTiK2BXjJIKUvHCx6e/ekW6pLNprIVjfFl
         LzlkgWzY/7ATCEcM/20QamCwIjnNZMhAhSW6sXARrzgD97SGRoGri5LOtQTZTFziLVfj
         vf+XUYUpbfXLZPuwZN4oswiJI2QM9DWuf2zS5VLP8eeHBfMY5PxB/dlb2xfIuOKwsxxr
         Vzeiwf2PsYjpWgqcc0MyY0urSOjroG6/aTv6DGGeh5Bo5ieFViT5nBJQO+zNJEvD5H3P
         5F66WsZ/WJ0Y6nSHlsrOWnWmuAuVgwh3KaUBgiQnz+3wQKpqd3yNJosqmEHgezo9zDi7
         yBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MZofWyob445pWeNhb7OktaRwpuZ/DPW8FberUsxg9WQ=;
        fh=3cQAK9CeWMgDgNkfKNdw/jeKHtaR4Nkt+vlYogRaBO4=;
        b=qUzOhB0JmCnJOhcktdOnlT17VpmZvFKOCTVe0a3sFhB06ZkarZPC7YuxGY7FxLwNcb
         X8TIjMBThrgJLow4m6BtSKcQ+7lddMcdtAWrLW1O0Xpko5ey1sqiCs5FNkivbAUOfbss
         ZJeE+N4YtIlsXZXxxPuIcIVFM/bZ6/A5Vamxdq9a8equr0Eti7OJViQHC8pymvYLp9zF
         YiN5hty98vSY/HI2w2hmsQO747qu6oZm3vPLrzJPKp3j4kyfIK9CrdhVA3Ui+YDTSZ7u
         DxEgc6no6O36uCHBN4KNuk9UHSQ3HC4buXnepxPZvxGXDxfk7dtHEjQge6f+rX/8ZkIs
         cKTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148487; x=1795753287; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MZofWyob445pWeNhb7OktaRwpuZ/DPW8FberUsxg9WQ=;
        b=IxQoOkAph/C2bppjxIagnZH9Zf+ykQbiU8SFG3DHZ12zacPoKijP95+A95slTbT16q
         riVtPSUx+J162NwXuhY5HHXGalFQZRwlkPeR6kj8GffVv+KFCG6QoAI7/PakCpQlyyXW
         NBEdLtx4sQI2R/7B1uz4tSpWHkyaxJFJRiK9DokGiVs8RAOOnF79rOnDzMXU9bB4aP1m
         S4LN3SkZUaCCUw4UkPvOQdztywPU0YKF6HnaAV2IoiUFOKvWJJX5rig8G7lZGEE0zeZY
         d9jfjfAMXE0v+g+wZQQk5pV3rR4lIqSGabfVm98fnY4jwB6D12h2oJY4Y6WR2h7UaxLH
         8pPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148487; x=1795753287;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MZofWyob445pWeNhb7OktaRwpuZ/DPW8FberUsxg9WQ=;
        b=PFDH5P6STSvchNqIPuZZBPzVXMCRjy/GqoQFScDsROQayhZemEZoRfivrWWMwOmZFu
         2s4WJtZWF1pw9cynTw7NnunfcydrCUomz3+htvcG3Fa3s7f1lKjV07pWmxXD5UOimRP6
         g46KdImJuV+mQZ4IY/xBpQ4RJZwoTBPcAtPeuhcu88jEkSZcWges9oRL/vpcMBJc26C7
         85n/DkcARz4hlUJBV8v2gLa6klhEiy2gyad0qDXEccU3xn0qUNU/tdCONXkhbSqwF3oD
         Y9oDd2u1ThdVqn5AkNcht53i56TixZ/gKR3CY1OUGRea11+ZImpoC4/ehL3iH+e15Atq
         f1uw==
X-Forwarded-Encrypted: i=1; AL+hErFMEgA/gT1wUmdTx9HTsLLDZWp/2PNlaaLLYEYftb5MgRHtA0HyINmmoX1kMuC6EN2+3g33wxPlCA==@kvack.org
X-Gm-Message-State: APuU4Z9ojPVKa2z6aJNxbwIfOqs+h+Y8PRcz4DKU+eUKU+wFT/uikRKY
	RnPS7oHvyRvKTWo6W3chi2jNHQEaN8R7Bz7bocPbxq+WT85FCuKhWNDyGGrx0wE3gpwqi8fLkHf
	Bym5QB9hlytQjcDPrmQr3dhG0MCUzIio=
X-Gm-Gg: AZFdTZc46Y+LPtkzCW6gyCck7FkXxjvwluT/WEW9Z5JaXvq4/v0N1oR6oP2Jw9ZIllv
	tHugsU0JOhLrCHWvBJtjnh6eFlen/iAii88lAKp+l3BAnYfFhncTSr7ug4wd0Ryx4v+mkfugWO5
	7zKlK61ao00jjy4T/+xrhJX+HKV1fAB8Ff+LR7Z1nI68orzZKeMt+H3zrMe9UsDHmk5d9uTrOSs
	OCcJCRxqlCzPPsJ8BL4XWKwiGMg3ejAcatvUp3UVd+OPLdShDeu0FH2SIqWoNmm4f+OGC8PYzh1
	9hYHjV0QOCvAjTTFTcxyn74uNM6c3c3rO6hRC1nyZnwDzi2L3vdwdxjTLX07/LUKclAJYyWHsdB
	v8T6PuTU4nocHJZqLi30RZXy8G4gbQrYnz7rdUSHY7YTYR/uyoIxrXnL4Rv3sQ8C6T0YwPC6XBc
	S5Sia5VH8pgtPeQ015l/5XEdG+
X-Received: by 2002:a05:690c:3603:b0:8b4:d8c6:4d9a with SMTP id
 00721157ae682-8b52049684amr7423927b3.48.1795148487000; Thu, 19 Nov 2026
 20:21:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119180015.933433-1-thnkslprpt@gmail.com> <av88TW3GQRvXJDwA@gremlin>
 <CA+jvY9E3XD5mJZ7V-+6HFxEkY1FHNGom42F-nxMZNGtOy9POqA@mail.gmail.com> <8e56f690-7031-4a57-abdd-a02c1c94782a@kernel.org>
In-Reply-To: <8e56f690-7031-4a57-abdd-a02c1c94782a@kernel.org>
From: Avi <thnkslprpt@gmail.com>
Date: Fri, 20 Nov 2026 06:20:49 +0200
X-Gm-Features: AclHuK_Fg9tRjIVo2CnJsvvToGmImP00awTc_YDWrnuAnE7j5TJSQHgt_xSP3vg
Message-ID: <CA+jvY9HQp6iDPGDTuVqrQNnw0ENDDq46_AwZqzcjXNcyFWqPsA@mail.gmail.com>
Subject: Re: [PATCH] mm: skip temporary folio allocation for anonymous UFFD
 missing faults
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liam@infradead.org, mhocko@suse.com, surenb@google.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-1.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CDC6040003
X-Stat-Signature: x9n6ou3hztmjikzxbaokt719sywrzr77
X-HE-Tag: 1795148487-969441
X-HE-Meta: U2FsdGVkX19oBrXf4I+r7brHCSX2QHZt0cQRX54RhugwVCfWSblTDhll0nMPWvGfI1csPHJRE7jz+MxqiGHIkV8zIvltDOaKlqEI6PT0d7dB0pNdFDDHD7OL7rSA1aqBAoORxwSQAa4PjyK0ZWZKV19i5oCphfmBXVWEFQ5WYdUPXUT4r1sm4tOpVs/4VtluMkKhC3YaJaci71uWDvFVICwAmTvPQ6sUt+xatfDdyTxDzvTOzfvhZ9msXPv8vS47tQQhpDZ+d33sVSDIfZK2yGu+5u43UINWXogRrG3Mbu8NkFLxVAAgsoWOu/szr0q782NKN719UdSbdKURrgXipcoeBanfKH2Ltzwj/eXncfpLY1B79Xnc812AL8u5wKYj6VMMjCHzJ0rMvlo7VCNUrfVAMRtgZ0j68VaTknIDodSCUxQHpBJzVTRxqGXGVpi4wj6uJJ0/eORJSIkGnpyWL/nlet9h45DSm3/XkXJLg9oR6U/7E6rdp5ZdMzZNopReKtiYDjhyyAPGg6pF3XhiaXsiQx52fzVUstvNkLjVgJ6rWpOHjn0s0FeKExXg5Z+1WUEaSOvKVLkUPspU6qtwg2IghiXccBYSWk59ajQ+SyDLh5XhC85oBviM/Ew5oeGvp1jCaiJQgag+TckJQ5x9h8vA/srNwItgQrxdvKU1gVNndVkTIvbz71GOiDf6Mf8ZChrjYQaI97ZC4OJaijTtjsBeOzhlZwAD8Cb/XUTV66Y0pNuckEQ87e4mGmLcr+KGiaie7G86JTlqwEtkKqiBD+9njEGJQsHuzRHgTrM11EdJiclnAdtREJuTAc8+Zn5iYSgM7exceFspcGTB3RkTKR7dtADgT+R40/P3YxhN5c4+td2/KRkiNyX3pNf0Tim5pZBiGVIRua90elidHHMNJXxOYb1J2y71mb8ouKIY5UPoU/W3T4Ycqij5OaayK63oDCF5ZkY+1SNz0OJHeK+
 lodRiZRe
 EDKvjAFHz375wcoW12AMeyh95wf5dnXbibVJmIek1M0PhD+J3ZLXU39CI7v9Vn2yM/EVv6W01fwWfbeFnN4dQlArLWOVEjgoz2bOrUHjMj1gXWY2dJqcVDuwHPGJV0mzFoul7QEXhpl0vU1S8SgNAhB1NpT+UIMoj9ScaxQ2QXxrxKIBL+rPboSnhf5X+Y57tdgx9yk4eCgDKtME4SKwBgwNkHoMGxevhMUlx9D2AdRHLpeaPQr4NUHOOzb+d/vkfuvVY+PykSvN0VodZRbZj1jMDeF01YJssLiqhW9ZzKmQs5oQdI96jOaP1fro1ZN2gkcrtcWFEbSWd0YcJH5jS/SHVXjt8ImIWeLbU4sRQ84KD9URHXPPQSi9SUWY1xAJwyv4uN1ZZ2w9tHQFfs8OvvlDAm4xlqo1J+Yzh0AO8/7ZziRkyIxY/qqoUCDzB+Ruim38NbacLoTLqnzYnuh1qSjE6T8n82LInMsN/7rBLy+5zePq4/ZTNtPDxaLL3Pd+SsoG68DcQvikgmi4/9eDvAVifl864ZuqXJNgJqfKQp2OLxE3QInLc9enrDAVLfuzRTO16MBqxWnx+VCa16+Ei3wnsyUyTMCr/musxTpFWlydvLJSFpJAjUv678tPn1JMYh3kglKW6nM2NVgOtCQIUcLxTum5wdQPq7KjtdzPdvlDT+gn0IJPksGO5sglqj7gqWXwQoZHHB1UxPX2HkFtAJJj7NCvMeBTggnpAcpcLDcTMQo/3v9VHGupn+12xetLBQZEDv5jpG5qiHdxm8DwqyODb52DZ5/OYt+bA6r6OgjN/98hAqu5hOb43JXMQRW8ZlkA2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David - the real motivation is very simple - avoiding the wasted
allocation (if possible).
That's it.

On Fri, Nov 20, 2026 at 12:35=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/19/26 20:31, Avi wrote:
> > Hi Lorenzo - I don't think you are in charge of all of Linux and can
> > decide who can and cannot submit contributions.
> > This is a legitimate improvement in my opinion - if you disagree that's=
 fine.
>
> May I ask which workloads you are running (for customers? etc) where you =
would
> care about this improvements? IOW, the real motivation.
>
> --
> Cheers,
>
> David

