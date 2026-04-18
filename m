Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14225F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523E46B02AF; Sat, 18 Apr 2026 07:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD8D6B02B0; Sat, 18 Apr 2026 07:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DE86B02B1; Sat, 18 Apr 2026 07:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A62C6B02AF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:51:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB13D8BC2D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:51:08 +0000 (UTC)
X-FDA: 84671510616.13.8F7B471
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 813C910000A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:51:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpGf9Fmo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776513066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5aQG5GWMid1alxq73M0knM9t2hiQZMBHQFCtdZIzRI=;
	b=PS9+a1lYCClb9OfP2/od/YKUxywORuNAujxfdWWF1e9EH8HP0UsM3YS0/A7oN0iE9oH+tV
	L8HshYw/yTqxrtIH0/w99n4Z2Oo/Hf15WAbpLVYkdynEPq7SMUHxmaE/MKliVxoRr3Dr8F
	NHP0Ci46+EcuoqsxGQxP8Pi8zYTGLt8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpGf9Fmo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776513066; a=rsa-sha256;
	cv=pass;
	b=3IujbOWUw6Zq5JOegceF9r82b+LWJXyfCo0d/VXevz7npmNyqNXEnJNot1p8XrWyK3rgaf
	NPpLH+/Cdyto7LmEyL5+c2zSThJKcZ04H5+mv8reIURLb8cKMInKX1Auh0rPdrePtqjBKc
	hY98J89hBegENBapP4/sCz31jAjIMi0=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-671ab90fc1fso3112904a12.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:51:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776513065; cv=none;
        d=google.com; s=arc-20240605;
        b=GKxLb0WUDxuVLY32MRS38EXU4RUlpXRLJo2EFizTd9UQ2x+JdR9VbRkv14cBv8E7wt
         i79OGwO9FfoGlheP2l538fXHHWOJhOjDszluoKUBUq8oCF0vX/oC+EeruYWeOaiTcIsY
         2SKU6RHWJafau0wuaCdbNNGSBsAoiqHwR2eJtLFiF6va8V+r1VPPsrF3OUCV3TOQVJcS
         zwPUnqAoipEuM5KmuNfCiZERMMsHOfKdgf9mpA4T77U77epptiHi1uwqoe0Qm6F1ERMz
         MENHiLGM8TIfeugfIxwUWv1Kn9LNx8wNUUXmCux9taSMmx73fpMFx4MAh/cw6yhDa58P
         +kzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e5aQG5GWMid1alxq73M0knM9t2hiQZMBHQFCtdZIzRI=;
        fh=mCChuJiJCwPbHu2xNKwpHRtST0ZLvkzlJlDB3YxATeU=;
        b=jQIMkei8AC4pnsavspBP6+Jb7+7Vq95nmZRFMUCe9pP0MHUxMhA5BEmnWv44hbVY2o
         DlAxxq/p2+eV1ShW+M2HCyw0PW+4QTjI7koQxNbB7e/JX+QNDY90sGfYnQj6sR6Klqud
         PJR+WCeamxHxiCWioYo/DJsvYQdwIupsKlBwGtRmnL+ExwtKEl8PlgxnV1htWqctI0e3
         9Mf2Uy88KTmWa99886FIPVNPtQAPeoc+PNbUL8PN706meBwNlR3F0i0Z3FskG9MSokP1
         rIHb9dWSLpjQ6GlefbjBSRKK9FvPdIgp3r7etRDWEJk6BsLOZAnOSqEyqm8BL3vBPoMO
         xR2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776513065; x=1777117865; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5aQG5GWMid1alxq73M0knM9t2hiQZMBHQFCtdZIzRI=;
        b=YpGf9FmoCrWkRetrzoJHQWgMd3uvKIicW0gtWh744gIzBikaHHDBqPtKjOYS9kJg9V
         jstCVA1RzkRQX3CxS+bsPLydJ+lANzgtVi45Ks+EHkcE7yhRFh/hwpJdBzpUmAcG/dTg
         hm034Ldy0SUu34uy81r2SBcMtuEtoQkrf3SK3C9CDiTLM9EvOFDIcGNsM6+SjCbApRnP
         F448Rw7mMGGRRz3J3HmeW3zIwkBVgrFE01WrZ0J5A26wh6Qq5fQHT9bED12bylAmglbi
         CL+pL3iVqDIuwKVhtCSKAv6ICY6r+gBYxjZrStSp7mBrEKj+mW8+avft0CJpYv0VF4j2
         C7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776513065; x=1777117865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e5aQG5GWMid1alxq73M0knM9t2hiQZMBHQFCtdZIzRI=;
        b=K2alUzVEg/rYAB5Z82jg4JtLmvOCL8CFZpAjRaXA0AGRStKayPYXyMFBwam9Stf5qG
         IiUV8er5+2qcl+Wvd3D3TeObum+oNckQa/f04s8rPy1Cz+6tx5lJYcQHVaE+cE8REv6Z
         iv333WSJFHdUKZsi28aQe1KZ+80iL+NFPuTd1Mm9fQF7bYBxCMxmEm/xw1rhDoU9G8BA
         L5JZSuFpyDDk+HFUeUcGA64sgQF/6xCj+UjJxwfzeUQRmru/fR/SdWs2xc/xsdM4qH9h
         koaE3/gOQsmTeGa1B9ZGJUcrq1YpR5amjoX3pJSglFnKl7tk96MjC0+QeMjjs8NrTS9r
         j1Nw==
X-Forwarded-Encrypted: i=1; AFNElJ+W4ZnSbObFjpMEGBGApRc8JBRfulG58QtMM93a+dAq3gS7K90MhAHYu3CQCAekXie+KVmV6es9cw==@kvack.org
X-Gm-Message-State: AOJu0YzRqBSyQdixejVbkv+ZOMIW2RLZBoexfIk5ao+L8y9xNm14w/NC
	9s+cGTAqbjG/n8xETyNrC7G7p4DOrltIBVvUSmPDGhb9dkcAjBNxllNqKwrPatI+7qGBXNjchXZ
	0DZnXtu5YkEPudWIDpZzocRhMqe5ADjNuOsyIALMEAg==
X-Gm-Gg: AeBDiesCvJxjIshnFEiwCPOksRlsfmtJFYxidy1s/XqHIspwoCnG06UyxQQIav/pM74
	7Q/FUT1iLw4W2yIGrnwUAI9Vu3Ix/ZkufqP+I31Gd5KWH8SGMZn+0gEoQocTuvDgzWd2YFU1NcZ
	9h0GClI0sTL4S5WmI7+8Vly6s1L9lQfzn9yPZaidwtdgiCZaPOaN6UucGEKRWl35dXX6ssQalOm
	bT3MJ7sErowHagrM/xgOrJdLQGom3fMYc7q4wA32qtHf3+2cNbm4U+YWLobCMjgSCuU9EOZDTor
	QbhdKIQSKbTXtfq47AOfqBSsWjgfLCQq3hlw5AjaVsWpZLMnbFA=
X-Received: by 2002:aa7:d7da:0:b0:670:8b7b:5004 with SMTP id
 4fb4d7f45d1cf-672bfedb106mr2130584a12.25.1776513063869; Sat, 18 Apr 2026
 04:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260417025123.2971253-1-wxy2009nrrr@163.com> <3a28d9d327d84ae192fb3dcb925a0674@honor.com>
 <CAMgjq7BsSMxia=nYA1n7d+sOq8RhRb-F6F7E6tt+R6buf7WZOQ@mail.gmail.com> <830980eb128a49c6adc55571b7015fab@honor.com>
In-Reply-To: <830980eb128a49c6adc55571b7015fab@honor.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 18 Apr 2026 19:50:26 +0800
X-Gm-Features: AQROBzDEsuRMUsx0r2tdE8SVOWXEc4G5DCwH4jAK9HWTAD-XjenAmOzXX7LLXIc
Message-ID: <CAMgjq7Cac7jo2PB4uUcr0usq6vQDRVSCFNQ8JBXD+7yHE+95rg@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: wangzicheng <wangzicheng@honor.com>
Cc: wangxinyu19 <wxy2009nrrr@163.com>, 
	"devnull+kasong.tencent.com@kernel.org" <devnull+kasong.tencent.com@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "baohua@kernel.org" <baohua@kernel.org>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"chenridong@huaweicloud.com" <chenridong@huaweicloud.com>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"david@kernel.org" <david@kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"kaleshsingh@google.com" <kaleshsingh@google.com>, "laoar.shao@gmail.com" <laoar.shao@gmail.com>, 
	"lenohou@gmail.com" <lenohou@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"stevensd@google.com" <stevensd@google.com>, "surenb@google.com" <surenb@google.com>, 
	"vernon2gm@gmail.com" <vernon2gm@gmail.com>, "weixugc@google.com" <weixugc@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com" <yuzhao@google.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, wangzhen <wangzhen5@honor.com>, 
	wangtao <tao.wangtao@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 813C910000A
X-Stat-Signature: 64n7qqbnhy3yixdpam449bwzi6uonppj
X-HE-Tag: 1776513066-405093
X-HE-Meta: U2FsdGVkX1/m2A79zPLOjkvCUnF1tgmRZCcyf6F9vCn5r28VRx1rpAhITpYjYAGqYl0anPEyrhqoeRv9jO6YqIR0YaIB5wuvXxR7+DqEG5SmdN1vLT6vAp+W6r5T3sO5YpGOR39GMeV6dkoqej7b8JnpvL8n+1ku3FVFBscnXaSWLMi2+c1U2IHrtN5buuuELucpHmeMK/BV7vM1ra0Fl6GrCffbUqXz7q/T0bYcHFpTU+jG5d+PmVo0vwwNrBfT+0idUF4mzApW+429x2sqC865NFldyCW8IpvkJZmLLsfjbuJgfPTGYLRpBCSoYRJ6EU097tWzueI9Q09ezYYPaf7fSiFxw+zGkHaNdrVyh0U6VnSj9SalAbVay222/syUVTrRkt0L2GB3+UmjZEsipRs/hVBJfL//oR6T88FFdqP0dKZLNT5OYIXTvN5Y74CRa7IEVXWQ5/m/mqW/7S63YFyjWVWFQHs65AAsPvJZvlId7sIhKRyaWvkUN28HQZ3KFsvGEXUAXUfSfApYa1ev334Rc02Tdn5PpDBWU22MCQ5b1WknlX+4Vf2TpE/7wms690DSnXw4VR2vlYaNuU5jaUqzDH+y8qP5ao3vjoZxgubKgWqGmseUpb9LCAAhjCaxLgYj8TeC2vjrlH0/GMODp+YUmMK2VqH3EFSACqzOZAURGia64ILs6b2hlpfkR/icJKJcYL5RV8VZ5fK6W2W4t1j0Ua6BMPhDtoXpP/15V5VeMtcOmTnyK7OzdG/8y928DOqTzqOFd/GU9FSjgDdBlb7bCiXg2+3XZ3Htg2rjFem51WuHeobQKPaDAGr2aNUkVW+SH+fCs2doBfFnANiZBzFBRRNY840N4pXuEhD0d8OacA/OIbOCV0UE+OE+CGl7Db/m0KbLJzxLzjoaS1T5Gt5nB+b+zWgcODRRVhh59dQEavgfkwWE+xvW9qorRtHjhLlm6AcEi3pqqZcPaqb
 GIpptUZP
 zJdwW5L0odGSZWFI3cd1ygnCG5o0OUPOKnk6eZJDfpl8Wjp2gwhco6pj5kwwzHXpRnpp1DFYRIBZrWWFhN5jMwZ4HKiu3SjqnsAr8hPu9MeVGx9xPiaCZJQB00YF9qjZnUlHRWF8X3hf4+5CamRZunWc9zVWzlaH+XFhfyJhQkSwUS3+haYhERWsISnCQwqU3s3TgUsolUhi8ZYIjkHd2BpfjDFmzpFlSUPC7AgaKEh0IR95Qx/cr7wHUg+x2Goo+u5trSnqNYbRtKE5AZRiRGXRIU9Gcwx91GWRZCIGzAr/OBFmep5XmHYxuxlKEFZg3FO8yVoponxQsadRwAImwmLdFMczBtHqmYpoosglVmyEjp4EliWGJi5T8KZtN941Y3bEdSlgeDBl5OaSjsYeVt7MmusAB67VeiqMYUlUImwqUBvSr38Fq5reajQOrgsw8DtRJcIQLWcdxK1bGwTNwzph7plqvvimEJhF7M7eh7T9IPLB+na8eoaero8qn76uS2Zx/vSO4HrYMCT5C8J+tGMTQTMx5M4ISpNXNHQSzj65d3RMuQ5G68f+9do57dK674QgbZjlvX3LXEXgHSkupXoItbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 5:08=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
> There is indeed a relatively large gap between mm-unstable and our
> android16-6.12 tree. The series was backported manually and we only
> applied the changes required to make it build and run in our tree.
>
> Because of this, it is possible that some related changes from
> mm-unstable were not included, which may have affected the behavior or
> performance we observed. If this caused misleading results, we
> apologize for the confusion.
>
> Regarding vendor hooks, in our tree there is only one hook in
> get_nr_to_scan(). We tested with that hook disabled.
>
> The performance data was collected using Perfetto traces.
> Unfortunately those traces contain a large amount of runtime
> information and are not easy to share externally.
>
> If needed, we can also try to reproduce the test on a tree closer to
> mm-unstable once our chipset platform kernel tree gets updated to
> a newer version, to see whether the behavior still reproduces.
>
> Below is the patch we manually applied during the backport.
>

Hi Zicheng!

Thanks for sharing this. It helps a lot!

I'm still not sure how I can reproduce your issue though. Android have
many adaptive behaviors and vendors (in userspace) have many
customized policies too, so maybe some metrics change have unexpected
behavior.

>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f78cfe059f14..50109cd5e94c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1987,6 +1987,44 @@ static int current_may_throttle(void)
>         return !(current->flags & PF_LOCAL_THROTTLE);
>  }
>
> +static void handle_reclaim_writeback(unsigned long nr_taken,
> +                                    struct pglist_data *pgdat,
> +                                    struct scan_control *sc,
> +                                    struct reclaim_stat *stat)
> +{
> +       /*
> +        * If dirty folios are scanned that are not queued for IO, it
> +        * implies that flushers are not doing their job. This can
> +        * happen when memory pressure pushes dirty folios to the end of
> +        * the LRU before the dirty limits are breached and the dirty
> +        * data has expired. It can also happen when the proportion of
> +        * dirty folios grows not through writes but through memory
> +        * pressure reclaiming all the clean cache. And in some cases,
> +        * the flushers simply cannot keep up with the allocation
> +        * rate. Nudge the flusher threads in case they are asleep.
> +        */
> +       if (stat->nr_unqueued_dirty =3D=3D nr_taken && nr_taken) {
> +               wakeup_flusher_threads(WB_REASON_VMSCAN);
> +               /*
> +                * For cgroupv1 dirty throttling is achieved by waking up
> +                * the kernel flusher here and later waiting on folios
> +                * which are in writeback to finish (see shrink_folio_lis=
t()).
> +                *
> +                * Flusher may not be able to issue writeback quickly
> +                * enough for cgroupv1 writeback throttling to work
> +                * on a large system.
> +                */
> +               if (!writeback_throttling_sane(sc))
> +                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> +       }
> +
> +       sc->nr.dirty +=3D stat->nr_dirty;
> +       sc->nr.congested +=3D stat->nr_congested;
> +       sc->nr.writeback +=3D stat->nr_writeback;
> +       sc->nr.immediate +=3D stat->nr_immediate;
> +       sc->nr.taken +=3D nr_taken;
> +}
> +
>  /*
>   * shrink_inactive_list() is a helper for shrink_node().  It returns the=
 number
>   * of reclaimed pages
> @@ -2054,41 +2092,15 @@ static unsigned long shrink_inactive_list(unsigne=
d long nr_to_scan,
>
>         lru_note_cost(lruvec, file, stat.nr_pageout, nr_scanned - nr_recl=
aimed);
>
> -       /*
> -        * If dirty folios are scanned that are not queued for IO, it
> -        * implies that flushers are not doing their job. This can
> -        * happen when memory pressure pushes dirty folios to the end of
> -        * the LRU before the dirty limits are breached and the dirty
> -        * data has expired. It can also happen when the proportion of
> -        * dirty folios grows not through writes but through memory
> -        * pressure reclaiming all the clean cache. And in some cases,
> -        * the flushers simply cannot keep up with the allocation
> -        * rate. Nudge the flusher threads in case they are asleep.
> -        */
> -       if (stat.nr_unqueued_dirty =3D=3D nr_taken) {
> -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> -               /*
> -                * For cgroupv1 dirty throttling is achieved by waking up
> -                * the kernel flusher here and later waiting on folios
> -                * which are in writeback to finish (see shrink_folio_lis=
t()).
> -                *
> -                * Flusher may not be able to issue writeback quickly
> -                * enough for cgroupv1 writeback throttling to work
> -                * on a large system.
> -                */
> -               if (!writeback_throttling_sane(sc))
> -                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> -       }
> +
> +       // sc->nr.unqueued_dirty +=3D stat.nr_unqueued_dirty;
> +       // leave nr_unqueued_dirty in scan_control to keep integrity
>
> -       sc->nr.dirty +=3D stat.nr_dirty;
> -       sc->nr.congested +=3D stat.nr_congested;
> -       sc->nr.unqueued_dirty +=3D stat.nr_unqueued_dirty;
> -       sc->nr.writeback +=3D stat.nr_writeback;
> -       sc->nr.immediate +=3D stat.nr_immediate;
> -       sc->nr.taken +=3D nr_taken;
> -       if (file)
> -               sc->nr.file_taken +=3D nr_taken;
> +       // if (file)
> +       //      sc->nr.file_taken +=3D nr_taken;
> +       // leave nr_taken in scan_control to keep integrity
>
> +       handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);

Since it's not a full backport, the backport itself might be buggy or
be missing things or dependency. For example, this part, I dropped
nr_unqueued_dirty and file_taken in this series, that's perfectly fine
for upstream mainline after 2f05435df932 (6.19), but I just checked
android16-6.12 branch of AOSP, if you remove this counter update here,
maybe some dirty reactivation path is completely broken, or if there
are related downstream metrics or user, they are broken.

> -static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control=
 *sc)
> +static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int sw=
appiness)
>  {
>         int gen, type, zone;
> -       unsigned long total =3D 0;
> -       int swappiness =3D get_swappiness(lruvec, sc);
> +       unsigned long seq, total =3D 0;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> -       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         DEFINE_MAX_SEQ(lruvec);
>         DEFINE_MIN_SEQ(lruvec);
>
>         for_each_evictable_type(type, swappiness) {
> -               unsigned long seq;
> -
>                 for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
>                         gen =3D lru_gen_from_seq(seq);
> -
>                         for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
>                                 total +=3D max(READ_ONCE(lrugen->nr_pages=
[gen][type][zone]), 0L);
>                 }
>         }
>
> +       return total;
> +}
> +
> +static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control=
 *sc)
> +{
> +       unsigned long total;
> +       int swappiness =3D get_swappiness(lruvec, sc);
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +
> +       total =3D lruvec_evictable_size(lruvec, swappiness);
> +
>         /* whether the size is big enough to be helpful */
>         return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
>  }
> @@ -4475,7 +4496,6 @@ static bool sort_folio(struct lruvec *lruvec, struc=
t folio *folio, struct scan_c
>                        int tier_idx)
>  {
>         bool success;
> -       bool dirty, writeback;
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
> @@ -4505,7 +4525,7 @@ static bool sort_folio(struct lruvec *lruvec, struc=
t folio *folio, struct scan_c
>
>         /* protected */
>         if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDT=
H) + 1) {
> -               gen =3D folio_inc_gen(lruvec, folio, false);
> +               gen =3D folio_inc_gen(lruvec, folio);
>                 list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>
>                 /* don't count the workingset being lazily promoted */
> @@ -4520,26 +4540,11 @@ static bool sort_folio(struct lruvec *lruvec, str=
uct folio *folio, struct scan_c
>
>         /* ineligible */
>         if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
> -               gen =3D folio_inc_gen(lruvec, folio, false);
> +               gen =3D folio_inc_gen(lruvec, folio);
>                 list_move_tail(&folio->lru, &lrugen->folios[gen][type][zo=
ne]);
>                 return true;
>         }
>
> -       dirty =3D folio_test_dirty(folio);
> -       writeback =3D folio_test_writeback(folio);
> -       if (type =3D=3D LRU_GEN_FILE && dirty) {
> -               sc->nr.file_taken +=3D delta;
> -               if (!writeback)
> -                       sc->nr.unqueued_dirty +=3D delta;
> -       }
> -
> -       /* waiting for writeback */
> -       if (writeback || (type =3D=3D LRU_GEN_FILE && dirty)) {
> -               gen =3D folio_inc_gen(lruvec, folio, true);
> -               list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> -               return true;
> -       }
> -
>         return false;
>  }
>
> @@ -4547,12 +4552,6 @@ bool isolate_folio(struct lruvec *lruvec, struct f=
olio *folio, struct scan_contr
>  {
>         bool success;
>
> -       /* swap constrained */
> -       if (!(sc->gfp_mask & __GFP_IO) &&
> -           (folio_test_dirty(folio) ||
> -            (folio_test_anon(folio) && !folio_test_swapcache(folio))))
> -               return false;
> -
>         /* raced with release_pages() */
>         if (!folio_try_get(folio))
>                 return false;
> @@ -4567,8 +4566,6 @@ bool isolate_folio(struct lruvec *lruvec, struct fo=
lio *folio, struct scan_contr
>         if (!folio_test_referenced(folio))
>                 set_mask_bits(&folio->flags, LRU_REFS_MASK, 0);
>
> -       /* for shrink_folio_list() */
> -       folio_clear_reclaim(folio);
>
>         success =3D lru_gen_del_folio(lruvec, folio, true);
>         VM_WARN_ON_ONCE_FOLIO(!success, folio);
> @@ -4577,8 +4574,9 @@ bool isolate_folio(struct lruvec *lruvec, struct fo=
lio *folio, struct scan_contr
>  }
>  EXPORT_SYMBOL_GPL(isolate_folio);
>
> -static int scan_folios(struct lruvec *lruvec, struct scan_control *sc,
> -                      int type, int tier, struct list_head *list)
> +static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec, =
struct scan_control *sc,
> +                      int type, int tier,
> +                          struct list_head *list, int *isolatedp)
>  {
>         int i;
>         int gen;
> @@ -4587,10 +4585,11 @@ static int scan_folios(struct lruvec *lruvec, str=
uct scan_control *sc,
>         int scanned =3D 0;
>         int isolated =3D 0;
>         int skipped =3D 0;
> -       int remaining =3D MAX_LRU_BATCH;
> +       unsigned long remaining =3D nr_to_scan;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> +       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
>
>         if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> @@ -4647,16 +4646,12 @@ static int scan_folios(struct lruvec *lruvec, str=
uct scan_control *sc,
>         __count_memcg_events(memcg, item, isolated);
>         __count_memcg_events(memcg, PGREFILL, sorted);
>         __count_vm_events(PGSCAN_ANON + type, isolated);
> -       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_B=
ATCH,
> +       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_sca=
n,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
> -       if (type =3D=3D LRU_GEN_FILE)
> -               sc->nr.file_taken +=3D isolated;
> -       /*
> -        * There might not be eligible folios due to reclaim_idx. Check t=
he
> -        * remaining to prevent livelock if it's not making progress.
> -        */
> -       return isolated || !remaining ? scanned : 0;
> +
> +       *isolatedp =3D isolated;
> +       return scanned;
>  }
>
>  static int get_tier_idx(struct lruvec *lruvec, int type)
> @@ -4698,33 +4693,36 @@ static int get_type_to_scan(struct lruvec *lruvec=
, int swappiness)
>         return positive_ctrl_err(&sp, &pv);
>  }
>
> -static int isolate_folios(struct lruvec *lruvec, struct scan_control *sc=
, int swappiness,
> -                         int *type_scanned, struct list_head *list)
> +static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c, struct scan_control *sc, int swappiness,
> +                          struct list_head *list, int *isolated,
> +                         int *isolate_type, int *isolate_scanned)
>  {
>         int i;
> +       int scanned =3D 0;
>         int type =3D get_type_to_scan(lruvec, swappiness);
>
>         for_each_evictable_type(i, swappiness) {
> -               int scanned;
> +               int type_scan;
>                 int tier =3D get_tier_idx(lruvec, type);
>
> -               *type_scanned =3D type;
> +               type_scan =3D scan_folios(nr_to_scan, lruvec, sc,
> +                                       type, tier, list, isolated);
>
> -               scanned =3D scan_folios(lruvec, sc, type, tier, list);
> -               if (scanned)
> -                       return scanned;
> +               scanned +=3D type_scan;
> +               if (*isolated) {
> +                       *isolate_type =3D type;
> +                       *isolate_scanned =3D type_scan;
> +                       break;
> +               }
>
>                 type =3D !type;
>         }
>
> -       return 0;
> +       return scanned;
>  }
>
> -static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, =
int swappiness)
> +static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,=
 struct scan_control *sc, int swappiness)

The signature change in upstream comes with the proportional
protection, simply changing that downstream might be missing things
and we are not on the same baseline.

>  {
> -       int type;
> -       int scanned;
> -       int reclaimed;
>         LIST_HEAD(list);
>         LIST_HEAD(clean);
>         struct folio *folio;
> @@ -4732,19 +4730,23 @@ static int evict_folios(struct lruvec *lruvec, st=
ruct scan_control *sc, int swap
>         enum vm_event_item item;
>         struct reclaim_stat stat;
>         struct lru_gen_mm_walk *walk;
> +       int scanned, reclaimed;
> +       int isolated =3D 0, type, type_scanned;
>         bool skip_retry =3D false;
> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
>         spin_lock_irq(&lruvec->lru_lock);
>
> -       scanned =3D isolate_folios(lruvec, sc, swappiness, &type, &list);
> +       /* In case folio deletion left empty old gens, flush them */
> +       try_to_inc_min_seq(lruvec, swappiness);
>
> -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> +                                &list, &isolated, &type, &type_scanned);
>
> -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS =
> lrugen->max_seq)
> -               scanned =3D 0;
> +       /* Isolation might create empty gen, flush them */
> +       if (scanned)
> +               try_to_inc_min_seq(lruvec, swappiness);
>
>         spin_unlock_irq(&lruvec->lru_lock);
>
> @@ -4752,10 +4754,10 @@ static int evict_folios(struct lruvec *lruvec, st=
ruct scan_control *sc, int swap
>                 return scanned;
>  retry:
>         reclaimed =3D shrink_folio_list(&list, pgdat, sc, &stat, false);
> -       sc->nr.unqueued_dirty +=3D stat.nr_unqueued_dirty;
>         sc->nr_reclaimed +=3D reclaimed;
> +       handle_reclaim_writeback(isolated, pgdat, sc, &stat);
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> -                       scanned, reclaimed, &stat, sc->priority,
> +                       type_scanned, reclaimed, &stat, sc->priority,
>                         type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>
>         list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> @@ -4804,6 +4806,7 @@ static int evict_folios(struct lruvec *lruvec, stru=
ct scan_control *sc, int swap
>
>         if (!list_empty(&list)) {
>                 skip_retry =3D true;
> +               isolated =3D 0;
>                 goto retry;
>         }
>
> @@ -4813,28 +4816,14 @@ static int evict_folios(struct lruvec *lruvec, st=
ruct scan_control *sc, int swap
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
>                              int swappiness, unsigned long *nr_to_scan)
>  {
> -       int gen, type, zone;
> -       unsigned long size =3D 0;
> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         DEFINE_MIN_SEQ(lruvec);
>
> -       *nr_to_scan =3D 0;
>         /* have to run aging, since eviction is not possible anymore */
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
>                 return true;

And you lost the DEF_PRIORITY early-return here.

>
> -       for_each_evictable_type(type, swappiness) {
> -               unsigned long seq;
> -
> -               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
> -                       gen =3D lru_gen_from_seq(seq);
> +       *nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
>
> -                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> -                               size +=3D max(READ_ONCE(lrugen->nr_pages[=
gen][type][zone]), 0L);
> -               }
> -       }
> -
> -       *nr_to_scan =3D size;
>         /* better to run aging even though eviction is still possible */
>         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
>  }
> @@ -4844,27 +4833,55 @@ static bool should_run_aging(struct lruvec *lruve=
c, unsigned long max_seq,
>   * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for mem=
cg
>   *    reclaim.
>   */
> -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c, int swappiness)
> -{
> -       bool success;
> -       unsigned long nr_to_scan;
> -       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> -       DEFINE_MAX_SEQ(lruvec);
> +// static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control=
 *sc,
> +//                        struct mem_cgroup *memcg, int swappiness)
> +// {
> +//     unsigned long nr_to_scan, evictable;
> +//     bool bypass =3D false;
> +//     bool young =3D false;
> +//     DEFINE_MAX_SEQ(lruvec);
> +
> +//     evictable =3D lruvec_evictable_size(lruvec, swappiness);
> +//     nr_to_scan =3D evictable;
> +
> +//     /* try to scrape all its memory if this memcg was deleted */
> +//     if (!mem_cgroup_online(memcg))
> +//             return nr_to_scan;
> +
> +//     // nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_=
scan);
> +//     // not exist in the android code
> +//     nr_to_scan >>=3D sc->priority;
> +
> +//     if (!nr_to_scan && sc->priority < DEF_PRIORITY)
> +//             nr_to_scan =3D min(evictable, SWAP_CLUSTER_MAX);
> +
> +//     trace_android_vh_mglru_aging_bypass(lruvec, max_seq,
> +//             swappiness, &bypass, &young);

This part looks really hackish... I'm not sure if anything is wrong.

> +//     if (bypass)
> +//             return young ? -1 : 0;
> +
> +//     return nr_to_scan;
> +// }
> +/*
> + * For future optimizations:
> + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for mem=
cg
> + *    reclaim.
> + */
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_cont=
rol *sc)
>  {
> -       long nr_to_scan;
> -       unsigned long scanned =3D 0;
> +       bool need_rotate =3D false, should_age =3D false;
> +       long nr_batch, nr_to_scan;
>         int swappiness =3D get_swappiness(lruvec, sc);
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> -       while (true) {
> +       nr_to_scan =3D get_nr_to_scan(lruvec, sc, memcg, swappiness);
> +       if (!nr_to_scan)
> +               need_rotate =3D true;
> +
> +       while (nr_to_scan > 0) {
>                 int delta;
> +               DEFINE_MAX_SEQ(lruvec);
>
> -               nr_to_scan =3D get_nr_to_scan(lruvec, sc, swappiness);
> -               if (nr_to_scan <=3D 0)
> +               if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> +                       need_rotate =3D true;
>                         break;
> +               }
>
> -               delta =3D evict_folios(lruvec, sc, swappiness);
> +               if (should_run_aging(lruvec, max_seq, swappiness, &nr_to_=
scan)) {

Here should_run_aging() clobbers the same nr_to_scan the loop, which
changes the reclaim behavior dramatically compared to this series.

> +                       if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> +                               need_rotate =3D true;
> +                       should_age =3D true;
> +               }
> +
> +               nr_batch =3D min(nr_to_scan, MIN_LRU_BATCH);
> +               delta =3D evict_folios(nr_batch, lruvec, sc, swappiness);
>                 if (!delta)
>                         break;
>
> -               scanned +=3D delta;
> -               if (scanned >=3D nr_to_scan)
> +               if (should_abort_scan(lruvec, sc))
>                         break;
>
> -               if (should_abort_scan(lruvec, sc))
> +               /* For cgroup reclaim, fairness is handled by iterator, n=
ot rotation */
> +               if (root_reclaim(sc) && should_age)
>                         break;
>
>                 cond_resched();

And here you are not doing "nr_to_scan -=3D delta". Maybe the reclaim
will keep going on in a extreme aggressive way? The new design meant
to use nr_to_scan as budget, not a bool.

>         }
>
> -       /*
> -        * If too many file cache in the coldest generation can't be evic=
ted
> -        * due to being dirty, wake up the flusher.
> -        */
> -       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D sc->nr.=
file_taken)
> -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
> -       /* whether this lruvec should be rotated */
> -       return nr_to_scan < 0;
> +       return need_rotate;
>  }
>

So I did a quick look of this backport, it does looks very buggy
itself with several inconsistent part I can identify on spot, and
besides I'm not sure if there are more gaps in other parts in the
downstream with this series.

I think you are simply not testing the same thing as I posted. It pass
the build doesn't mean it's correct, at least the reactivation, budget
and the aging part might be kind of broken.

Don't worry, your workload and concern definitely make sense, but I
think we really need to come up with some reproducible tests that can
be benchmarked upstreamly to avoid confusion and inaccuracy, so all
our cases can be better covered.

I'll also try to do a few more tests on my android phone. And feel
free to provide more suggestion or cases :)

