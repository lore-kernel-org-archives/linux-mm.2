Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AA3C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376786B008A; Mon,  7 Sep 2026 22:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3279C6B008C; Mon,  7 Sep 2026 22:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23CC56B0092; Mon,  7 Sep 2026 22:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC16D6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:20:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 668EAA44D3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:20:07 +0000 (UTC)
X-FDA: 85188990054.04.82852CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97928C0008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:20:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b36bZQMd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788834005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pbDnxDIH0qmbdfsGAHNMpoph9eK9/0Z3/l8TeWzN48=;
	b=FuUIYpiO/bMx3Y59+6PYaTI+3g1EynPUoXZmYCAyTVH8xa5mUx2qGjSWhiFmn9WP9jBAMQ
	kLeWRjSyanCYSEG53of9SEqLkbuPJyVgM0QOb60dXd9mPC7gV5LUQdsYlEA5D5El3X1755
	PCW4JPMqLoGQJ2Dkrqbc9k/afS2d6lA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b36bZQMd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788834005;
	b=aemoEbuVqs4ayNmTFKTi6Fn4eHnABGMpTtxppfrzWe61fT0ma0zm+yw+538S8BHdj4505E
	qG2+AilNKkPXNRjtycm7OsPq/lv0le5CoIVoTeRB2M9BKg/j7OdkOTI4WUP3GMBPnI6OGa
	O6rFBr+qUldBZsSmSAH0PLLaNpj33VY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCFF760A74
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2471F00ACF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788834004;
	bh=5pbDnxDIH0qmbdfsGAHNMpoph9eK9/0Z3/l8TeWzN48=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=b36bZQMdwqoSg//jcbxKou1emB9sxZgNa3/6gMD7EjdCcbrUEviVAfuORht1rDoIt
	 GoAeVHKdV+5CuQL1K2hzdimUbzCcFCAvdwdzDUGlGMlYaTcchnqccTcWfUi/Awr93U
	 0H+ijLxSeW4TEIboZiJAIOtoWoEvkCbhpu/4xhnZQa0iZo7Yn8GcJ+fk1K3NOX0fh8
	 71/LazsGiTiliE/Xxdu36EN8P0+QrNjyoajKtKTkse0fqiONJnlInKJnCb1I7HUAY0
	 fsRzEdjACEAsu7fqrEkTYmPy3Achkb3Qkg9ZRxxAgTnUN0tC630twK+NO2CJciLxfj
	 M0KKa5hlJsUHw==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51bfad59921so50935721cf.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 19:20:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwx92oK/Dkta0XIeoLpSNvshdAV423w1qXF76O/aKMak9CNTtCnyemrbo1hra7bPO8ASwnhe61b6w==@kvack.org
X-Gm-Message-State: AFuF++nH1BYUei+J/OiSI/+JqWJ7PkAYrIUlfjAdLVNC/N08+J2pXsdp
	2LE3r1ENIej4izYeTXwnuXOMMUXZ0dvqfdUJC8xnNAX5OHkGYiApwm52b9F+mbACrUj9cFPijBO
	bY4BTGupSsU818akeuElBA+p3nWKXjWM=
X-Received: by 2002:ac8:6f05:0:b0:530:4310:5399 with SMTP id
 d75a77b69052e-53054a43079mr311383871cf.49.1788834003745; Mon, 07 Sep 2026
 19:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 8 Sep 2026 10:19:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yYu42Byaw4_e28DcyA968QQNJDraen6TjBwBMrZhGjfw@mail.gmail.com>
X-Gm-Features: AcwNN1UbPQKd6ZVAdz0uVWJMqoHwwYO5PYM5oZ_iCNVu-78enjJdQsACpWeO2Cg
Message-ID: <CAGsJ_4yYu42Byaw4_e28DcyA968QQNJDraen6TjBwBMrZhGjfw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Baoquan and me as MGLRU reviewers
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97928C0008
X-Stat-Signature: hd6fy54nkzpg3izbo615cdz11tad7sh6
X-Rspam-User: 
X-HE-Tag: 1788834005-364702
X-HE-Meta: U2FsdGVkX1+Bc3O68nH7QAhBivKvvUuH6OjDQinGGy9g3TA1rDmK09jRMJn0o18pOHq/G2FOGvip9Co8JslAc+at0sYeVSBUUirvpqMG3oNL4PRVuhVdakZPHSV59McALCZin9HxcAY/egt5JKLOQ3hqH+5v3m4BQO4pyIOmpxPAPf9Q79rVTrClsMuePNmNv6SIRmLLwSyrAimPeFS7DN8MkKQfWHouJ4arg0Uk6CusHW21epwp3ia4u5OG85+lp3xf9YYrFsYDqILu++9eGTi2nK9ETfp2mxfdLs9rh5vHpC+CJhClYsLIVqYCT7uv8kZHgUyhJOdmEzNVD/q6nW05P4MHHB3y8ABoN6/2K8u5ns4BfGrSBPmqAq1UGbI48BA0svrTZlmMXwvBVmI5GP82RDwuMDoi7nEsvBM8qacY3C+0V8ZxHlg4yhS1or5bYv49IVcy1SFT8Wmn1UFag93C8e8EqMv4q581lyAQzjLRfRZVTbPDYbg33MWkYqAU1LgxLxYpiwazGGOAZfiWKsYxFJDWvQSLKagabY5M8ScRcVfIxAMngmHLppoMxuNzAMIKjVc42cQjDAvVOGqDQL1cuUgvyIsGCmr/eg3QntRBo4sUX0H4KnpdNu2Iuw5hgKBNHNpPsvTsBf5847AWtQi3uhh8Hw3Fwco/r+YqWKPSW8EVDIzC/qdD/+OYw+A/3v7WE7Xx28INiW/TDlOpI88xqYR8C8RuE2G9ExYuDFUH1zHgvrxSe8XnXkRoLSBE0MLWYB7J87paPEnXnNu5v4/c2ojKZ89Yh+94t30WQQey2X//MNY61dbyftI1hpD6UqCe2WkCmrT8WuyYzR14v5LLyDG0dcPgY3vrKWF46aWpsw2FDKNrAoSWUahkFm2CBLaM+PwzIaHYGWUQWRQUxW/3s7IxS2JfjAMDXGPn2KEQoddzO5z4TFI9KdaPgr+EEbn1xux5s+t95Ch5lL5
 PtJj9ACf
 rKcNmew6Uyip8WJBuFd+uRGS0dH5Rh976CtoZ3GMGKN/4f01S7NiSc2mg0XqPKechNgjCVAi6NVeAzVREz2d/IZZLFM6sFThbFQ6cgkL90eYJMtScK87inAKjM59bxq7jqEmsKS98gDzc+KtB5DSlym8gQqMbFHQj4byIw33zR4Z/rH1aSjumj8fM6D6JdLcHBWiJZL5zRdpEnF13plTZsijdXEaheQ9UmEW6mN0hdFtl/REEXL544I2tmYOSQYer7JN4WBPXT6RjxK1RpbiGastPGT/kJM250Ak3T51GXvf3XyhuwxDzP/BhV8AiY6rptYP6rgRuke3iEDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 9:42=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Baoquan and I have been contributing MGLRU patches and helping review MGL=
RU
> related patches for some time. We will continue to follow MGLRU changes, =
so
> we'd like to be CC'd on MGLRU related patches.

Yes, this is very welcome.

Acked-by: Barry Song <baohua@kernel.org>

>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

