Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0573D2FEF9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E6D6B0005; Tue, 27 Jan 2026 18:52:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCCC6B0089; Tue, 27 Jan 2026 18:52:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94B16B008A; Tue, 27 Jan 2026 18:52:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B380F6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:52:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 080511401E4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:52:28 +0000 (UTC)
X-FDA: 84379395576.25.B17A200
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id EF0FE1C0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:52:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ML2qUyLN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769557946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZRvTKXPkrkt6X+J/Cjw1nYajRoQjv33aP+kK07JubU=;
	b=NJVGP51aT+nWOL4kfUKlp3cAY20s7i29ZRfBfgciyWvGn2mi6MsNb67kxiozZlgGZrkWqI
	MEp20c07hUWjk+LtwD9SkgwpOiOKVawUb0j75T3z6pbwJ6FtDbowtCYPwCpIwXkoElOIkr
	oKa+AJnL2mBeMpW3hLAZhSaCwc8n4PU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769557946; a=rsa-sha256;
	cv=pass;
	b=IuiUHp7V/yMm1RcF9qHRiIkbV3A6q5wlWMJ6ix4nI9XR21uY7qfb0nR5qdGBFZNdR11V/n
	yV7eVtQLzcum6QFL0XzUuHRgRz+NFD/LHGXtJbVR3gpAwOut6vgSOOZSOGUqvZA3J0w20o
	zPU9S8dPdlcjoot5ZU+9EboVQnYbsgA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ML2qUyLN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50299648ae9so80031cf.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:52:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769557945; cv=none;
        d=google.com; s=arc-20240605;
        b=VKJ8QNbyBNwXba7gP7sZyZ2ZrmO8qmkwr/av5i+HPV3uMHoeFcm+mQuo/g4q9eesi1
         rJW+ZFAbzRplcabKqN2e2gKH/U1nEVAFAbuEkLb+2Wt0ZlWfW9xw4ez7bY3zC9D5O0Wn
         D6GItIt4zo6qSZDfFyFoiU86mt7iBgKwzuDuEbnoB15VPl5n8FZUTDmAlzcutZ9Kc3sM
         X4jOzoWqSO+6qLgecbv42SEbAqA4Scq4yArnBGbAdkYz/ASiwSOGCLjeWMtfCCnSxEZh
         VXe8saH39ZYYH2NS0XY3OgELxWxnjEobAvLkAhz3XE8ldKeUGIFekDByD89/vQdK9yJT
         h8AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+ZRvTKXPkrkt6X+J/Cjw1nYajRoQjv33aP+kK07JubU=;
        fh=mK93UanB9zpDqdHyBOb4b260A5P7Zn8xrzshL3I08Mg=;
        b=kmEHKqdOis2D4UjpctaySpzotQljJ4PArVm8GnWmhuBAQ9k8jCNcO6g+/Vt1rdkyD6
         rqMti+5eTvE1APxYL658j2lFhsBhyGJHq+nyEsj/5qf8wfhz/OE4oPyXCXv+aoS6aZ0m
         LkTwfJQfZWnA+BYIKx1KbQTmu/9kjzLKb+MvMnwyGWtKnuKxQ4ufNuleQw2iYuzTYSR+
         gG3AjKkuJhXwhwLAIdS/qjBLKvlvPasmLV+Fm4M/PpEnP9aqkeo1z5tvZ5yKuCPAF8cs
         hiyV5CSMx/RZ8ax7vw0hyXZlsajb4XLt6IPtgVh9cNc217PJ4yQfF7FGeYDiSJKOVcvn
         PzLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769557945; x=1770162745; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ZRvTKXPkrkt6X+J/Cjw1nYajRoQjv33aP+kK07JubU=;
        b=ML2qUyLN4xIevi28y0CfsdMdEYa91601CBRzoAt1w+y28Ij5I48Dp3SrXiKHzBgkA6
         vggejBwpdJiQZ0VkPhCz7d7LnbImkNb/bjaB/qhFVmgMbjKJTauruKe168Gh6/XCskgl
         HKJ/uEuq39uvN9yt9umbCcZiM6YWJyK+zvfkSmS+jg4NLzCE0XRsf2jTtD1XU3Ac6ra2
         NuNjuTM7extN3DKmaTmeMl9pahSk8WTg4KHal1MWWSXZZTqLL+2ZKERCRRf2j7p8BIag
         gtn50J/sHG/2Xbf53FrNUBM3Ed6xAaU7mLQE41sRjTG3QwkXWxMJoMlCi9HORoDeFcmA
         Sdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769557945; x=1770162745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+ZRvTKXPkrkt6X+J/Cjw1nYajRoQjv33aP+kK07JubU=;
        b=KK/VIL9YomDxnOOZCTBBm46IkRP0+OYjr1vxmKnIJTFdVVrj/5JFC6iy1L9Qaocivw
         8RdV2LjKPE9WCcsobvG6Z6M++69/11Uc4P+wW9UZzbmX03ZrbN7n4SgL23LQ39lHtkUN
         BS0JYZOP4+GryGD2/6p+pMc/pgC+mM8mSMnaRRqDXQZPPCq4bgeqvqlduyjTWRqEz9RC
         uUluk4EosWT4rO+4ilEqszRQ6zaCP1U/yg/zYzxopH9ZJECvAVEti0wXnuGowL7xZz0L
         sbwY7ZGU3EU4JxqSdtLjill0xFId3V0bXq8ki7ii5CfDhMozUxeYfXxBgWMG5uE97pMR
         hZlQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5vQhmnCrxpclHJyg9dGUh2a2UGAKuDTsV2o+T1I2OpdN61nr+IuyaVrEXEjh1Zkt3sZu348IyVA==@kvack.org
X-Gm-Message-State: AOJu0Yx1NuCIALj7I95Ub9/FMMMQ8wXEPK3iVDUfsKgOXg+TBasbbH8e
	uB5XYrTGhVso76n+2RF2TqvqH/8V9CaeUa1u5MGFqGrWq5VLFbayP0AezAt5jEysrvlfg7rbIaD
	QntyN3d5A0vuk2eAqohnmktgaO6CcyYL/qDKlrGY7
X-Gm-Gg: AZuq6aL/deWy8NQtYC9JQtH7MOOXqlcsHSEihdVmrZ2vNFr/xO1e8EuvVqQESN9/Lkj
	IyDF0qU0Ky9uVwYs/ErwnrUOPPhQAvUdFSu13j36EDqKYllEKhZT4B26DjJxmeZ48pbAoVki0JT
	C0WBpW5DXAPH1EoGqb2jTbA7YmhCHUnImOiTMznwtH6/r4H9o6UdZvhBg3xJsDZ1q2H5ndVzB57
	d4mxH4QclpMYGTiZXlP7gUSE+9q1Z8c/RErD13n557SQOnjK/Npps6YtYrAeUUE1wDNea2qOH75
	aiNkRgAnoYuvLms1UMb8NuE57Q==
X-Received: by 2002:a05:622a:6681:b0:501:197d:32af with SMTP id
 d75a77b69052e-503340e2447mr9436431cf.0.1769557944532; Tue, 27 Jan 2026
 15:52:24 -0800 (PST)
MIME-Version: 1.0
References: <697400dc.a70a0220.35de72.000a.GAE@google.com> <20260124113148.2398-1-hdanton@sina.com>
 <CAJuCfpEcqAiK-z=EZ5im12F2wfGHYogiMHaTC4t5uopLmBKQPw@mail.gmail.com>
 <CAJuCfpEJUeQcpfbh-0KTsp1UdTs5yrKTbvAV6QOKdQHJZ2HWww@mail.gmail.com>
 <CAJuCfpF_a=-kTZLdOzZpKrWhO2CyowwT+PdZ7_tP-cXxe23DiQ@mail.gmail.com> <CAEf4BzZxEVSFtu7uozpr-7NvRqt2WqjzmHrvQgG6TDoJQ9p_AQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZxEVSFtu7uozpr-7NvRqt2WqjzmHrvQgG6TDoJQ9p_AQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 27 Jan 2026 15:52:12 -0800
X-Gm-Features: AZwV_QhT6quY5zxTYPH6FFpp-MS0l0k7PdIWHA9EixLsSgXcFdvVYcINLCHWJIk
Message-ID: <CAJuCfpHMJ-5hP+eHpD1jyJtdmFb9qaSfaZ8GdsHY8BrorvUdkg@mail.gmail.com>
Subject: Re: [syzbot] [block?] possible deadlock in blkdev_read_iter
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>, 
	syzbot <syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com>, axboe@kernel.dk, 
	linux-block@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EF0FE1C0008
X-Stat-Signature: n8wupor95n4i53wiqkdt7rm6wwyoxens
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769557945-999952
X-HE-Meta: U2FsdGVkX19dOSE+7oopntnGLvqVyd1X4VlGO/ritwksiLIanNBkBPNK2mJc4A5gns6qB1XhGN+sqpRKCVqBPSM9+98bYeyLi0t6VSqykhR1OpwIbGmD0J/VlkSa8hqEgcBYdyPamGfUJX7qc1rnEVNcv1+raqqlCkpQSqu82rQiMNe3N+SQCuulLtp7nTags8/J8hTO3Jxvmjm0nxXW5WYV2p4ICpUUkwZEkRGHOxWT+ACqqjF7Y0SgmJe9h/SqRu65F5krwvBXlKpCma//jfpmmLhqIzJpaQ+iNa2rW+AvnCvTsIfhwD1n0g0njrZ1Jd+CSB22FcQdF4u9uXwOPKlv+CZrYR9KL22YE5fAZEAKnntB/0Wvnz50WhreKsdMl6Mv4HsMn18LKuo9At8JKR7mwu7e8ubjLndfaFapOSfVgsi8nwQNYH2pmNoBu8HCOjsT3mNyrpYwg7XyaGKT72MD5A7PFaSJmhj3wyPtR1Aquus5x8NLwA10d7/mkomJwZOYDKcLbSuDomh9ycCjzq2LSrnMkXmmkAHG5BRsiJbKbcHG02bIfWnCWp8juAlkn28mn8In+2sODx3CyvpRgBVah0YmgYySoFSzGHdd37rMakL+N0bUztYEUXcwXyfyo9IescpO1uH2/6KmSKyWDmI3oOV7SxTiig6pYJ3bRZq3OiaBGE1mvl6dWFqU/zZnDkcl8B9p8jMwb7UCtcoJUxjV2rKxcRBuRu0acfAPSVS2SafC+YzpRoZdmwgecHF32ZxvEcLJ4kknmk1ejHwGrGArOpEyhAN6G0viwSbac+DZ5YgxlfAuXZHUyO96zoPTQKNozgWgRBOldHkMRsCoTZosM63P7Eq1EeOJxT7ro1Q0T/hgeeuKpBQoSvI4PiTJrzzkcyCLQSe01g6nRzvhkTVTFayz5NOV3vlPlLwshawk6HRVhQrCRwAneOauLzauqGfGj8wSPH70LujEEtL
 g9tAr7ow
 q+7fWBPVdin6ItSjqdaudM6QUI4krj4jeCoytqiC5eqQzW49/xCNPopXV4lnrOZ9VGSqteGzg2AKwbE4vGdAmNnuAs69903sRH4liGqgWthObvL5Ivz5qAYlpW1jPyG5VGw9iBPyEnQHrY8g72Hrtq7YFXeORGeGmMgKsX0QlaG+QQ7kmSjW5zEyCCawEKi5PEKxDhdQ6+0L4xT47ZA8rFfDdz5T2djN1vPM2nAByMKf2WBC41xWHUdkVvQCH46E/5nWpLjBZcauM9qqYl/ljDX1X4vj2RRJf+Wfsnt/R+JApg498QD+ZT9HV6qlKmMdn6mSSsVu2yA3cJXERJEIYryaGfU/5My1inn+QrSn88dPhn0L+VMybNh3Cmtok4B0DcJfhI5U6i/26chOnP8Ep1b5vPmDqLQGXTdMvETKxEVzyId5ATYyWnqltF/7QbKweMegG27rxXwWojr+itBMWqTHB5jKii6JKcC/dZLsOkqWAx8gVwtWeyQRRhkyTU8q60zdQLMImVtI87Diaquuq2cXcd8Esoit9xqSoT9ZSfOQEg4bZ0ihAOaW4U10FNw7I1vV6PeW2cmT/mx5tB64JtK/PQbOFxqAOianZRG/XdtNvm0M7KicFJIzmq/kcyc9eFqr5oPrxll5SngsABGJr81OOKXaZBYvn+nZ5N5RFPKrMFReKbRHvZSykc1Blwbnj+5e7OMsiSJStZixAUMKFMW4Rmc1mqEfYq0U1xTf/Jy9HQ01klkV7sSZIUU91AanKcW6sl00m9PQvsUiYJdrVYAaXA1OZHp+0TbB/J+wwXSLAQNH/Haj2rqIIJ12pjGkDB1DDPN4dFY3Ri6NPQLFy/Y7AjKi9hzrOASfhYfka/zPXEmZnSSuQNByxWb9d3H5HFUL1CNBe8Iku+8ZhKKHyutZrsYFT4pkJFNF/EUDv09SJUHS00qOZLS3gzuzpxwLfIdaEy7QlqDn3Qvpg4Yt3+9E1SgYX
 MALcxhTB
 JI6UhBJyUN44ITJW9VDd8C1euKThylcg9fzKOY51i3fk9AeCM2ZLVp1+p6GUYndJQVxdNltMmc7Q2D60OMTzSMeokR3eX5+BNrjrNqkRD0mNqUNvghupvs11impB92VfTaGN69gz5opKHMbHvv6C56oA3J/Ta+Gz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:51=E2=80=AFAM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jan 26, 2026 at 6:22=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Mon, Jan 26, 2026 at 2:33=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Mon, Jan 26, 2026 at 9:20=E2=80=AFAM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > > >
> > > > On Sat, Jan 24, 2026 at 3:32=E2=80=AFAM Hillf Danton <hdanton@sina.=
com> wrote:
> > > > >
> > > > > Add Lorenzo and Suren
> > > >
> > > > Thanks!
> > > >
> > > > >
> > > > > > Date: Fri, 23 Jan 2026 15:14:36 -0800
> > > > > > Hello,
> > > > > >
> > > > > > syzbot found the following issue on:
> > > > > >
> > > > > > HEAD commit:    24d479d26b25 Linux 6.19-rc6
> > > > > > git tree:       upstream
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D100=
033fa580000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D185=
9476832863c41
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4e70c=
8e0a2017b432f7a
> > > > > > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (=
GNU Binutils for Debian) 2.40
> > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1=
1451b9a580000
> > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D104=
5e852580000
> > > > > >
> > > > > > Downloadable assets:
> > > > > > disk image (non-bootable): https://storage.googleapis.com/syzbo=
t-assets/d900f083ada3/non_bootable_disk-24d479d2.raw.xz
> > > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/d0f3c47f6=
869/vmlinux-24d479d2.xz
> > > > > > kernel image: https://storage.googleapis.com/syzbot-assets/8002=
31513703/bzImage-24d479d2.xz
> > > > > >
> > > > > > IMPORTANT: if you fix the issue, please add the following tag t=
o the commit:
> > > > > > Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.=
com
> > > > > >
> > > > > > WARNING: possible circular locking dependency detected
> > > > > > syzkaller #0 Not tainted
> > > > > > ------------------------------------------------------
> > > > > > syz.0.17/6091 is trying to acquire lock:
> > > > > > ffff8881061287a8 (
> > > > > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_shared =
include/linux/fs.h:1042 [inline]
> > > > > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter+0=
x19e/0x500 block/fops.c:855
> > > > > >
> > > > > > but task is already holding lock:
> > > > > > ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e=
/0xed0 mm/mmap_lock.c:334
> > > > > >
> > > > > > which lock already depends on the new lock.
> > > > > >
> > > > > >
> > > > > > the existing dependency chain (in reverse order) is:
> > > > > >
> > > > > > -> #2 (vm_lock){++++}-{0:0}:
> > > > > >        __vma_enter_locked+0x260/0x770 mm/mmap_lock.c:72
> > > > > >        __vma_start_write+0x21/0x160 mm/mmap_lock.c:104
> > > > > >        vma_start_write include/linux/mmap_lock.h:213 [inline]
> > > > > >        mprotect_fixup+0x4e3/0xb80 mm/mprotect.c:768
> > > > > >        setup_arg_pages+0x4a2/0xbb0 fs/exec.c:670
> > > > > >        load_elf_binary+0xb5b/0x4fe0 fs/binfmt_elf.c:1028
> > > > > >        search_binary_handler fs/exec.c:1669 [inline]
> > > > > >        exec_binprm fs/exec.c:1701 [inline]
> > > > > >        bprm_execve fs/exec.c:1753 [inline]
> > > > > >        bprm_execve+0x8c2/0x1620 fs/exec.c:1729
> > > > > >        kernel_execve+0x2ef/0x3b0 fs/exec.c:1919
> > > > > >        try_to_run_init_process init/main.c:1506 [inline]
> > > > > >        kernel_init+0x14a/0x2b0 init/main.c:1634
> > > > > >        ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
> > > > > >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:24=
6
> > > > > >
> > > > > > -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > > > > >        __might_fault mm/memory.c:7174 [inline]
> > > > > >        __might_fault+0x113/0x190 mm/memory.c:7168
> > > > > >        _copy_to_iter+0x1c2/0x1710 lib/iov_iter.c:196
> > > > > >        copy_page_to_iter lib/iov_iter.c:374 [inline]
> > > > > >        copy_page_to_iter+0x12a/0x1e0 lib/iov_iter.c:361
> > > > > >        copy_folio_to_iter include/linux/uio.h:204 [inline]
> > > > > >        filemap_read+0x6b1/0xe40 mm/filemap.c:2851
> > > > > >        blkdev_read_iter+0x1ac/0x500 block/fops.c:856
> > > > > >        new_sync_read fs/read_write.c:491 [inline]
> > > > > >        vfs_read+0x8bf/0xcf0 fs/read_write.c:572
> > > > > >        ksys_read+0x12a/0x250 fs/read_write.c:715
> > > > > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > > > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > >
> > > > > > -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> > > > > >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > > > > >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > > > > >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> > > > > >        __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:52=
37
> > > > > >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > > > > >        lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > > > > >        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > > > > >        inode_lock_shared include/linux/fs.h:1042 [inline]
> > > > > >        blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > > > > >        __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > > > > >        freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > > > > >        __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > > > > >        do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > > > > >        procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > > > > >        vfs_ioctl fs/ioctl.c:51 [inline]
> > > > > >        __do_sys_ioctl fs/ioctl.c:597 [inline]
> > > > > >        __se_sys_ioctl fs/ioctl.c:583 [inline]
> > > > > >        __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > > > > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > > > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > >
> > > >
> > > > It looks like:
> > > > #0 is executing PROCMAP_QUERY ioclt, read-locks vm_lock and then ca=
lls
> > > > build_id_parse()->__build_id_parse(...,
> > > > may_fault=3Dtrue)->__kernel_read() which eventually takes
> > > > inode->i_rwsem.
> > > > #1 is a file-backed page fault which asserts that it might take
> > > > mmap_lock for read.
> > > > #2 is load_elf_binary()->mprotect_fixup() which write-locks both
> > > > mmap_lock and vm_lock. I'm guessing it already holds inode->i_rwsem
> > > > before write-locking these locks.
> > > >
> > > > Originally I thought the issue is most liley introduced in
> > > > d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
> > > > per-vma locks"). But if #2 indeed takes inode->i_rwsem before
> > > > write-locking mmap_lock, then the problem should exist even before
> > > > that change when we didn't use vm_lock and relied on mmap_lock...
> > > >
> > > > I'll try to analyze this more before attempting a fix.
> > >
> > > I was able to reproduce the same issue even after reverting
> > > d9d1c2d81797. The deadlock in this case is simpler and involves
> > > mmap_lock instead of vm_lock (see below).
> > > Looks like the race is between the read() syscall and do_procmap_quer=
y().
> > > I'll continue investigating, in the meantime CC'ing Andrii.
> >
> > So, here is a cleaner version of that report (with d9d1c2d81797 reverte=
d):
> >
> >  -> #1 (&mm->mmap_lock){++++}-{4:4}:
> >         __might_fault+0xed/0x170
> >         _copy_to_iter+0x118/0x1720
> >         copy_page_to_iter+0x12d/0x1e0
> >         filemap_read+0x720/0x10a0
> >         blkdev_read_iter+0x2b5/0x4e0
> >         vfs_read+0x7f4/0xae0
> >         ksys_read+0x12a/0x250
> >         do_syscall_64+0xcb/0xf80
> >         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> >  -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> >         __lock_acquire+0x1509/0x26d0
> >         lock_acquire+0x185/0x340
> >         down_read+0x98/0x490
> >         blkdev_read_iter+0x2a7/0x4e0
> >         __kernel_read+0x39a/0xa90
> >         freader_fetch+0x1d5/0xa80
> >         __build_id_parse.isra.0+0xea/0x6a0
> >         do_procmap_query+0xd75/0x1050
> >         procfs_procmap_ioctl+0x7a/0xb0
> >         __x64_sys_ioctl+0x18e/0x210
> >         do_syscall_64+0xcb/0xf80
> >         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> >  other info that might help us debug this:
> >
> >   Possible unsafe locking scenario:
> >
> >         CPU0                    CPU1
> >         ----                    ----
> >    rlock(&mm->mmap_lock);
> >                                 lock(&sb->s_type->i_mutex_key#8);
> >                                 lock(&mm->mmap_lock);
> >    rlock(&sb->s_type->i_mutex_key#8);
> >
> >   *** DEADLOCK ***
> >
> > Both threads are calling blkdev_read_iter(), which uses
> > inode_lock_shared() to read-lock inode->i_rwsem. I'm not sure why CPU1
> > shows lock() instead of rlock(). So both threads read-lock
> > inode->i_rwsem and mmap_lock but in a different order. IIUC, with
> > read-locks this should not deadlock until some other thread
> > write-locks the mmap_lock in between and this becomes a real deadlock:
> >
> >         CPU0       CPU1         CPU2
> >         ----       ----         ----
> >    rlock(&mm->mmap_lock);
> >                                 rlock(&sb->s_type->i_mutex_key#8);
> >                    wlock(&mm->mmap_lock) <-- waiting for CPU0
> >                                 rlock(&mm->mmap_lock); <-- waiting for =
CPU1
> >    rlock(&sb->s_type->i_mutex_key#8); <-- waiting for CPU2
> >
> > I believe in the original report this write-locking thread was the one
> > calling mprotect_fixup().
> >
> > Per https://docs.kernel.org/mm/process_addrs.html#lock-ordering,
> > inode->i_rwsem should be locked before mm->mmap_lock, so
> > procfs_procmap_ioctl() has to be fixed to follow this lock ordering.
> > One possibility I can think of is to use build_id_parse_nofault()
> > first and if it fails because the required page is not faulted, we do
> > freader_init_from_file(), then drop the mmap/vma lock and execute
> > freader_fetch() outside of these locks to fault in that page. Once
> > that's done, we'll retry the whole operation and this time
> > build_id_parse_nofault() should pass (unless we already evicted that
> > page, which is extremely unlikely and in that case, we'll retry
> > again).
> >
> > I tried a POC with build_id_parse_nofault() but without the whole
> > dance with freader_init_from_file/freader_fetch and the deadlock is
> > gone. Andrii, WDYT?
>
> I don't like it :) Too much complexity, _nofault() variant only makes
> sense for BPF in non-sleepable contexts. I think this can be fixed
> simpler and cleaner. We don't need to hold VMA lock while fetching
> build ID. Build ID works with vma's vm_file, so we can just get its
> reference, drop vma lock, then fetch build id. Below diff passes our
> BPF selftests. Might need to think about a bit leaner code changes,
> but the idea should be clear. Diff below will be butchered by gmail,
> but you can fetch it at [0]. Do you mind validating that deadlock is
> gone? Thanks!

Sure. I'll test it later today, once I'm home.

>
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/andrii/bpf-next.git/c=
ommit/?h=3Dprocmap-query-vma-deadlock-fix&id=3D7faf95b63a8a7ac6e78b6d90101c=
94bfa6ecdfd1
>
> Author: Andrii Nakryiko <andrii@kernel.org>
> Date:   Tue Jan 27 10:46:04 2026 -0800
>
>     procfs: avoid fetching build ID while holding VMA lock
>
>     Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 81dfc26bfae8..564bf82e3731 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -656,6 +656,7 @@ static int do_procmap_query(struct mm_struct *mm,
> void __user *uarg)
>         struct proc_maps_locking_ctx lock_ctx =3D { .mm =3D mm };
>         struct procmap_query karg;
>         struct vm_area_struct *vma;
> +       struct file *vm_file =3D NULL;
>         const char *name =3D NULL;
>         char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf =3D NULL;
>         __u64 usize;
> @@ -720,6 +721,9 @@ static int do_procmap_query(struct mm_struct *mm,
> void __user *uarg)
>                 karg.dev_major =3D MAJOR(inode->i_sb->s_dev);
>                 karg.dev_minor =3D MINOR(inode->i_sb->s_dev);
>                 karg.inode =3D inode->i_ino;
> +
> +               if (karg.build_id_size)
> +                       vm_file =3D get_file(vma->vm_file);
>         } else {
>                 karg.vma_offset =3D 0;
>                 karg.dev_major =3D 0;
> @@ -727,21 +731,6 @@ static int do_procmap_query(struct mm_struct *mm,
> void __user *uarg)
>                 karg.inode =3D 0;
>         }
>
> -       if (karg.build_id_size) {
> -               __u32 build_id_sz;
> -
> -               err =3D build_id_parse(vma, build_id_buf, &build_id_sz);
> -               if (err) {
> -                       karg.build_id_size =3D 0;
> -               } else {
> -                       if (karg.build_id_size < build_id_sz) {
> -                               err =3D -ENAMETOOLONG;
> -                               goto out;
> -                       }
> -                       karg.build_id_size =3D build_id_sz;
> -               }
> -       }
> -
>         if (karg.vma_name_size) {
>                 size_t name_buf_sz =3D min_t(size_t, PATH_MAX,
> karg.vma_name_size);
>                 const struct path *path;
> @@ -779,6 +768,28 @@ static int do_procmap_query(struct mm_struct *mm,
> void __user *uarg)
>         query_vma_teardown(&lock_ctx);
>         mmput(mm);
>
> +       if (karg.build_id_size) {
> +               __u32 build_id_sz;
> +
> +               err =3D -ENOENT;
> +               if (vm_file)
> +                       err =3D build_id_parse_file(vm_file,
> build_id_buf, &build_id_sz);
> +               if (err) {
> +                       karg.build_id_size =3D 0;
> +               } else {
> +                       if (karg.build_id_size < build_id_sz) {
> +                               err =3D -ENAMETOOLONG;
> +                               goto out;
> +                       }
> +                       karg.build_id_size =3D build_id_sz;
> +               }
> +       }
> +
> +       if (vm_file) {
> +               fput(vm_file);
> +               vm_file =3D NULL;
> +       }
> +
>         if (karg.vma_name_size &&
> copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
>                                                name, karg.vma_name_size))=
 {
>                 kfree(name_buf);
> @@ -797,6 +808,8 @@ static int do_procmap_query(struct mm_struct *mm,
> void __user *uarg)
>
>  out:
>         query_vma_teardown(&lock_ctx);
> +       if (vm_file)
> +               fput(vm_file);
>         mmput(mm);
>         kfree(name_buf);
>         return err;
> diff --git a/include/linux/buildid.h b/include/linux/buildid.h
> index 831c1b4b626c..7acc06b22fb7 100644
> --- a/include/linux/buildid.h
> +++ b/include/linux/buildid.h
> @@ -7,7 +7,10 @@
>  #define BUILD_ID_SIZE_MAX 20
>
>  struct vm_area_struct;
> +struct file;
> +
>  int build_id_parse(struct vm_area_struct *vma, unsigned char
> *build_id, __u32 *size);
> +int build_id_parse_file(struct file *file, unsigned char *build_id,
> __u32 *size);
>  int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char
> *build_id, __u32 *size);
>  int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf=
_size);
>
> diff --git a/lib/buildid.c b/lib/buildid.c
> index aaf61dfc0919..c0002129d526 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -271,7 +271,7 @@ static int get_build_id_64(struct freader *r,
> unsigned char *build_id, __u32 *si
>  /* enough for Elf64_Ehdr, Elf64_Phdr, and all the smaller requests */
>  #define MAX_FREADER_BUF_SZ 64
>
> -static int __build_id_parse(struct vm_area_struct *vma, unsigned char
> *build_id,
> +static int __build_id_parse(struct file *file, unsigned char *build_id,
>                             __u32 *size, bool may_fault)
>  {
>         const Elf32_Ehdr *ehdr;
> @@ -279,11 +279,7 @@ static int __build_id_parse(struct vm_area_struct
> *vma, unsigned char *build_id,
>         char buf[MAX_FREADER_BUF_SZ];
>         int ret;
>
> -       /* only works for page backed storage  */
> -       if (!vma->vm_file)
> -               return -EINVAL;
> -
> -       freader_init_from_file(&r, buf, sizeof(buf), vma->vm_file, may_fa=
ult);
> +       freader_init_from_file(&r, buf, sizeof(buf), file, may_fault);
>
>         /* fetch first 18 bytes of ELF header for checks */
>         ehdr =3D freader_fetch(&r, 0, offsetofend(Elf32_Ehdr, e_type));
> @@ -324,7 +320,11 @@ static int __build_id_parse(struct vm_area_struct
> *vma, unsigned char *build_id,
>   */
>  int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char
> *build_id, __u32 *size)
>  {
> -       return __build_id_parse(vma, build_id, size, false /* !may_fault =
*/);
> +       /* only works for page backed storage  */
> +       if (!vma->vm_file)
> +               return -EINVAL;
> +
> +       return __build_id_parse(vma->vm_file, build_id, size, false /*
> !may_fault */);
>  }
>
>  /*
> @@ -340,7 +340,16 @@ int build_id_parse_nofault(struct vm_area_struct
> *vma, unsigned char *build_id,
>   */
>  int build_id_parse(struct vm_area_struct *vma, unsigned char
> *build_id, __u32 *size)
>  {
> -       return __build_id_parse(vma, build_id, size, true /* may_fault */=
);
> +       /* only works for page backed storage  */
> +       if (!vma->vm_file)
> +               return -EINVAL;
> +
> +       return __build_id_parse(vma->vm_file, build_id, size, true /*
> may_fault */);
> +}
> +
> +int build_id_parse_file(struct file *file, unsigned char *build_id,
> __u32 *size)
> +{
> +       return __build_id_parse(file, build_id, size, true /* may_fault *=
/);
>  }
>
>  /**
>
>
> >
> > >
> > > [   62.320932][ T9229]
> > > [   62.321471][ T9229] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [   62.323016][ T9229] WARNING: possible circular locking dependency =
detected
> > > [   62.324618][ T9229] 6.19.0-rc6-00001-g40bea6261b2a #42 Not tainted
> > > [   62.326013][ T9229] ----------------------------------------------=
--------
> > > [   62.327560][ T9229] hillf/9229 is trying to acquire lock:
> > > [   62.328821][ T9229] ffff888145b7b5a8
> > > (&sb->s_type->i_mutex_key#8){++++}-{4:4}, at:
> > > blkdev_read_iter+0x2a7/0x4e0
> > > [   62.331102][ T9229]
> > > [   62.331102][ T9229] but task is already holding lock:
> > > [   62.332722][ T9229] ffff888183a6e540 (&mm->mmap_lock){++++}-{4:4},
> > > at: do_procmap_query+0x39f/0x1050
> > > [   62.334795][ T9229]
> > > [   62.334795][ T9229] which lock already depends on the new lock.
> > > [   62.334795][ T9229]
> > > [   62.337072][ T9229]
> > > [   62.337072][ T9229] the existing dependency chain (in reverse orde=
r) is:
> > > [   62.338998][ T9229]
> > > [   62.338998][ T9229] -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > > [   62.340646][ T9229]        __might_fault+0xed/0x170
> > > [   62.341763][ T9229]        _copy_to_iter+0x118/0x1720
> > > [   62.342913][ T9229]        copy_page_to_iter+0x12d/0x1e0
> > > [   62.344167][ T9229]        filemap_read+0x720/0x10a0
> > > [   62.345298][ T9229]        blkdev_read_iter+0x2b5/0x4e0
> > > [   62.346480][ T9229]        vfs_read+0x7f4/0xae0
> > > [   62.347518][ T9229]        ksys_read+0x12a/0x250
> > > [   62.348584][ T9229]        do_syscall_64+0xcb/0xf80
> > > [   62.349707][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
> > > [   62.351116][ T9229]
> > > [   62.351116][ T9229] -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}=
:
> > > [   62.353012][ T9229]        __lock_acquire+0x1509/0x26d0
> > > [   62.354213][ T9229]        lock_acquire+0x185/0x340
> > > [   62.355323][ T9229]        down_read+0x98/0x490
> > > [   62.356441][ T9229]        blkdev_read_iter+0x2a7/0x4e0
> > > [   62.357619][ T9229]        __kernel_read+0x39a/0xa90
> > > [   62.358767][ T9229]        freader_fetch+0x1d5/0xa80
> > > [   62.359927][ T9229]        __build_id_parse.isra.0+0xea/0x6a0
> > > [   62.361232][ T9229]        do_procmap_query+0xd75/0x1050
> > > [   62.362434][ T9229]        procfs_procmap_ioctl+0x7a/0xb0
> > > [   62.363687][ T9229]        __x64_sys_ioctl+0x18e/0x210
> > > [   62.364863][ T9229]        do_syscall_64+0xcb/0xf80
> > > [   62.365977][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
> > > [   62.367394][ T9229]
> > > [   62.367394][ T9229] other info that might help us debug this:
> > > [   62.367394][ T9229]
> > > [   62.369637][ T9229]  Possible unsafe locking scenario:
> > > [   62.369637][ T9229]
> > > [   62.371237][ T9229]        CPU0                    CPU1
> > > [   62.372441][ T9229]        ----                    ----
> > > [   62.373687][ T9229]   rlock(&mm->mmap_lock);
> > > [   62.374688][ T9229]
> > > lock(&sb->s_type->i_mutex_key#8);
> > > [   62.376444][ T9229]                                lock(&mm->mmap_=
lock);
> > > [   62.377956][ T9229]   rlock(&sb->s_type->i_mutex_key#8);
> > > [   62.379165][ T9229]
> > > [   62.379165][ T9229]  *** DEADLOCK ***
> > > [   62.379165][ T9229]
> > > [   62.380952][ T9229] 1 lock held by hillf/9229:
> > > [   62.381971][ T9229]  #0: ffff888183a6e540
> > > (&mm->mmap_lock){++++}-{4:4}, at: do_procmap_query+0x39f/0x1050
> > > [   62.384162][ T9229]
> > > [   62.384162][ T9229] stack backtrace:
> > > [   62.385458][ T9229] CPU: 3 UID: 0 PID: 9229 Comm: hillf Not tainte=
d
> > > 6.19.0-rc6-00001-g40bea6261b2a #42 PREEMPT(full)
> > > [   62.385471][ T9229] Hardware name: QEMU Standard PC (i440FX + PIIX=
,
> > > 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> > > [   62.385477][ T9229] Call Trace:
> > > [   62.385482][ T9229]  <TASK>
> > > [   62.385487][ T9229]  dump_stack_lvl+0x100/0x190
> > > [   62.385505][ T9229]  print_circular_bug.cold+0x185/0x1d5
> > > [   62.385521][ T9229]  check_noncircular+0x14a/0x170
> > > [   62.385534][ T9229]  __lock_acquire+0x1509/0x26d0
> > > [   62.385547][ T9229]  lock_acquire+0x185/0x340
> > > [   62.385557][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
> > > [   62.385569][ T9229]  ? __pfx___might_resched+0x10/0x10
> > > [   62.385583][ T9229]  down_read+0x98/0x490
> > > [   62.385593][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
> > > [   62.385603][ T9229]  ? __pfx_down_read+0x10/0x10
> > > [   62.385612][ T9229]  ? lock_acquire+0x185/0x340
> > > [   62.385622][ T9229]  ? is_bpf_text_address+0x25/0x1a0
> > > [   62.385634][ T9229]  blkdev_read_iter+0x2a7/0x4e0
> > > [   62.385645][ T9229]  __kernel_read+0x39a/0xa90
> > > [   62.385658][ T9229]  ? __pfx___kernel_read+0x10/0x10
> > > [   62.385671][ T9229]  ? __lock_acquire+0x481/0x26d0
> > > [   62.385683][ T9229]  freader_fetch+0x1d5/0xa80
> > > [   62.385697][ T9229]  ? find_held_lock+0x2b/0x80
> > > [   62.385712][ T9229]  ? __pfx_freader_fetch+0x10/0x10
> > > [   62.385725][ T9229]  ? __asan_memset+0x27/0x50
> > > [   62.385737][ T9229]  __build_id_parse.isra.0+0xea/0x6a0
> > > [   62.385751][ T9229]  ? __pfx___build_id_parse.isra.0+0x10/0x10
> > > [   62.385766][ T9229]  ? __pfx_find_vma+0x10/0x10
> > > [   62.385774][ T9229]  ? __might_fault+0x129/0x170
> > > [   62.385788][ T9229]  do_procmap_query+0xd75/0x1050
> > > [   62.385798][ T9229]  ? __pfx_do_procmap_query+0x10/0x10
> > > [   62.385807][ T9229]  ? __sanitizer_cov_trace_switch+0x53/0x90
> > > [   62.385817][ T9229]  ? do_vfs_ioctl+0x226/0x13b0
> > > [   62.385828][ T9229]  ? __pfx_do_vfs_ioctl+0x10/0x10
> > > [   62.385839][ T9229]  ? putname+0xfc/0x1b0
> > > [   62.385846][ T9229]  ? putname+0x101/0x1b0
> > > [   62.385857][ T9229]  ? __x64_sys_openat+0x143/0x210
> > > [   62.385867][ T9229]  procfs_procmap_ioctl+0x7a/0xb0
> > > [   62.385877][ T9229]  ? __pfx_procfs_procmap_ioctl+0x10/0x10
> > > [   62.385888][ T9229]  __x64_sys_ioctl+0x18e/0x210
> > > [   62.385899][ T9229]  do_syscall_64+0xcb/0xf80
> > > [   62.385913][ T9229]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > [   62.385923][ T9229] RIP: 0033:0x412209
> > > [   62.385931][ T9229] Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1=
f
> > > 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
> > > 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d=
8
> > > 64 89 01 48
> > > [   62.385940][ T9229] RSP: 002b:00007fff380d5588 EFLAGS: 00000217
> > > ORIG_RAX: 0000000000000010
> > > [   62.385950][ T9229] RAX: ffffffffffffffda RBX: 00007fff380d56c8
> > > RCX: 0000000000412209
> > > [   62.385956][ T9229] RDX: 0000200000000180 RSI: 00000000c0686611
> > > RDI: 0000000000000004
> > > [   62.385962][ T9229] RBP: 00007fff380d55a0 R08: 0000000000000000
> > > R09: 00007fff380d5640
> > > [   62.385968][ T9229] R10: 0000000000000000 R11: 0000000000000217
> > > R12: 00007fff380d56b8
> > > [   62.385974][ T9229] R13: 0000000000000002 R14: 00000000004a0e40
> > > R15: 0000000000000002
> > > [   62.385982][ T9229]  </TASK>
> > >
> > >
> > >
> > > >
> > > > > > other info that might help us debug this:
> > > > > >
> > > > > > Chain exists of:
> > > > > >   &sb->s_type->i_mutex_key#8 --> &mm->mmap_lock --> vm_lock
> > > > > >
> > > > > >  Possible unsafe locking scenario:
> > > > > >
> > > > > >        CPU0                    CPU1
> > > > > >        ----                    ----
> > > > > >   rlock(vm_lock);
> > > > > >                                lock(&mm->mmap_lock);
> > > > > >                                lock(vm_lock);
> > > > > >   rlock(&sb->s_type->i_mutex_key#8);
> > > > > >
> > > > > >  *** DEADLOCK ***
> > > > > >
> > > > > > 1 lock held by syz.0.17/6091:
> > > > > >  #0: ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+=
0x10e/0xed0 mm/mmap_lock.c:334
> > > > > >
> > > > > > stack backtrace:
> > > > > > CPU: 2 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0=
 PREEMPT(full)
> > > > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3=
-debian-1.16.3-2~bpo12+1 04/01/2014
> > > > > > Call Trace:
> > > > > >  <TASK>
> > > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > > >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> > > > > >  print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
> > > > > >  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
> > > > > >  check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > > > > >  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > > > > >  validate_chain kernel/locking/lockdep.c:3908 [inline]
> > > > > >  __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> > > > > >  lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > > > > >  lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > > > > >  down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > > > > >  inode_lock_shared include/linux/fs.h:1042 [inline]
> > > > > >  blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > > > > >  __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > > > > >  freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > > > > >  __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > > > > >  do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > > > > >  procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > > > > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > > > > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > > > > >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> > > > > >  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > > > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > > >  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > > RIP: 0033:0x7ff1a238f7c9
> > > > > > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 =
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3=
d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > > > > RSP: 002b:00007ffebbe538b8 EFLAGS: 00000246 ORIG_RAX: 000000000=
0000010
> > > > > > RAX: ffffffffffffffda RBX: 00007ff1a25e5fa0 RCX: 00007ff1a238f7=
c9
> > > > > > RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 00000000000000=
04
> > > > > > RBP: 00007ff1a2413f91 R08: 0000000000000000 R09: 00000000000000=
00
> > > > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000000=
00
> > > > > > R13: 00007ff1a25e5fa0 R14: 00007ff1a25e5fa0 R15: 00000000000000=
03
> > > > > >  </TASK>

