Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E10CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B3E6B0005; Thu, 28 May 2026 23:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B636B0088; Thu, 28 May 2026 23:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C656B008A; Thu, 28 May 2026 23:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3C426B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:03:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71CA2410C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:03:30 +0000 (UTC)
X-FDA: 84818961780.29.D4900C0
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf25.hostedemail.com (Postfix) with ESMTP id B34B6A0006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:03:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="kVk/euDV";
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf25.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780023808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UO25NXFfDr1JQbaCIs3jucG8rynGMrbJHIu0alItT/Y=;
	b=tu5aGVMymVFU6GwfeYGESIJWBiF2qGFBQI2qMwKjootqt0zWhT8xg6yj017vI8hP2ykGv1
	7QO9CcvWj+Tolcx0BiEn6TmE7V39J6ADDtQmrtSO/k++M1hSYhbONcNvIg1U6zukDmVQ+2
	mTXbr4476Sv/hQXfQwNeS812iP6U+dM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="kVk/euDV";
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf25.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780023808; a=rsa-sha256;
	cv=none;
	b=VOxgpKGySzhJaMz/8LMIDZD98zyxq6gFvfOrMSFWiSzWQbWXsMh3ZUIQRBtZe1VL6eY88W
	HHSUc6PYBSPRAr5tNo4J3+3pPCXvpk2cBMpcf5K0nqsA005an9fdVjI+9Vp4NrR9ZhZW3a
	THdNHdwj7GHYJIXihEox3ITstEKwAuE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780023778;
	bh=UO25NXFfDr1JQbaCIs3jucG8rynGMrbJHIu0alItT/Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=kVk/euDVNUIjx0cu5qU99sYMYIfIZZUnQCYtHPTU8cmJ2wpbFw/1E6g1xUKTiqCQR
	 TIW+z9XctVHJnGZajAM/NOjSVVrW+eMrce7NnnUMguXS3+k2/VjiHiO5BJ8/7xyRBY
	 H4w+s+fFePFG88rMsGo/+BB8MG6PTpk4Hzc0bsxA=
X-QQ-mid: zesmtpsz1t1780023764tac51051f
X-QQ-Originating-IP: MfmWebu0CGkWeYxMGyswxnR9rxACMxe/KsnSWW94zTo=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 11:02:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 772953753065975309
EX-QQ-RecipientCnt: 8
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	niecheng1@uniontech.com,
	shuah@kernel.org
Subject: Re: [PATCH 0/2] selftests/damon: fix and validate memcg filter memcg_path handling
Date: Fri, 29 May 2026 11:02:41 +0800
Message-ID: <7C41953A77335257+20260529030241.1554009-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528143204.153713-1-sj@kernel.org>
References: <20260528143204.153713-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: N9ftk+EKvgGZRNFpA5ZkVMwXFBAZUMF2lE8x9u/XxaiHv/lREbo/jm1B
	wWVf8/WOPK7qJM44SZsww58VvLgaCYqeQchTwXiWR+1i0Sa0j4iQHQyqHaaUQXyXqRXGZTs
	nB8bKXUQu+xFlZtGLfngs+2mEz6Mr1X3mpfkAJPI7zOb8nHoFN7T44/jYxsZd6NFMJao5yf
	iVX/WlvKvPO6iF556bHMQWctQc0XDsjdrIoEovOAm/JgvxYsI8kroF9vzKe9Ygl9BeCMgK8
	mJN0FviM+FekvDZFHnkwMkBVTaI7xdBaAYl4rsXBvjjj4c/uWAP6G3g+lBrXsgtmJ7bHRzn
	FtVmPrAv7cAUNoZTw6ZJWVjUMdyzcXRQ+qQ0rU/9z+qNFxZ508QQL/XYDRGSu1CMeLU0Ahi
	+4ozrwMQL4FFsF8MgRjM/CAH5p7Kqv8fmln7FvdSSPRQCKdJxhkvYAcUfXG/MPOzl2T+4lN
	KFfKiPG4HKJugXmoNPJ2tHqkdMRvKOv2uDiPYOkMMWW2uMrZUBX1DFklHnLJEKzEHkpFMkP
	GF18ELSuqAWb4AkFyz0By7hTOZAVQ66cWYIMsXDf/KuCqGtoFWbITTx4F9tjuv3D6dyj7VD
	JHGdi/EPRLmXc/zT/RqsXqXyV6D/A4qgWH/vRMh2w4a968+HTLAf/jXaMGaPZDtCYDBPs2q
	SdL63oDu3daj2V7kGfCX0SUu0t9L2RZb+q3K26pNNwIGT8RpNNRt8D9UR2lDU5n7An1/rvE
	glLxYPJ1zQ12u85bcvBnUY7Bm42LK5ZFaiv14CYXGztKfiDGyohyK1BMIGk5SZnYSTconbx
	OywVhFG3Uba/puGEMVo2l5DOX2rbL32dlqhydsZ/tIvixk/3rn9oZJHYZKEWTVsfA2DXaPD
	rndK2aDm76txi3MhT6HOKJ+2YUqpQ+wVa4GHbouvHZU7gAzqTB4JsTzRYiG+CpqhJsdt1Ug
	W7PSero523YMtAe6xeH8j5hUuwEpd2JoLuFevemAto4iSQTjJ8aZMGpFbZ+86Xc3bMi2ntT
	vfJvy6/JPTRVs4emMniRs9ktjKaIE53+Il3ZTWfUmb2HJ1Yhibthiq9V27Jpv3yUzaXnJ9/
	tohxeDTO9sEdKLYvca1FrE=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B34B6A0006
X-Stat-Signature: oqkttpd9yder7q17xbrznmeqmp5anufr
X-Rspam-User: 
X-HE-Tag: 1780023805-489008
X-HE-Meta: U2FsdGVkX18eH2s/NSsBn8vKQOnllcH2EUraUv0JwF5WSEjNNjHJ0eqwn+QdNg/wK52ACz/8bPFjyw1UnHPWhLnY6pWOv4cQE48uVpCnTEhu/tS06qWYaebJtUJuMJwvYxt/D+QR4M7GHSu0iPGTQmIrShpE4+a8uHXlueKGGlDRoaYW3ToW7uyjyV9lrSgpNYC308dFIF8yDvZSkZm39rrItpSo/59M9+9NDrdw/jYlTaS9t6RYcGx0QTNyqOIN1p9PnTAzAb754G25PcnzeClBaKKLn9r7RW8502SfRAgZ7Hy0ko7nAURJrECr183/Tt0Pw+M+GHMcA0+QN7x3XwA9p3sP3GF50/L8tSq0IKN5jRhfkk3Yf8tHavO4R9v4jJ5BS+RTdks7pFwyzeXzDhBOstZK5Oe1GZ8XJBypPIRQXgk95ic6Ssh/1/OwHTUW/dptIn9l7uDqQ3vITWpeZHXmK8RFsJDtpE1Oof4Q3S/6GlqSsa7sWIKQ+HQLopRBdDSaX0pRz+NowPhPIDEM1Ax9U02KuamIU3WxHIqPUpT3A/weWV0R71fh9QRnl4SY97jyNZI07OYOGEw5Y1qBdNvTEtI8JjuoQ5zA12uhwKFhXowMz71+4r89DONdk7pVYzvJFf6m+sPKKTj8vkFie0+opJododndWM5NPwRma5mdeQ44rnVY/X9ZvCwgB9q/E8ar3SdLOHEI1aflvNguXvV3xrkG5acld7MvGjkL0n1iBDJJBOtjEQptV0XipCZWiFRJc5WWt3USV1+MrS2oAp77TNbg6ozG15psbpy9unfr7WOydDo5xPL8K5pOnS3fH/xU3GvgXwkSySdqFNz6/ksarZfLs0JfffniywokJIABN8lFMv3Tlp4yZAkGeZxpsnalHZdyfXvRXs58dKUBqQgNKzk8sVtZ37YfkaJEZt3bOxuK5TD/MROLqaENGb3+fAz87AK+V9j4G9a/qKI
 In5VoPdO
 ZWR87eLoEhhpGfbpt56eQfQc7xzcRWokPFaNHsnGRS7cd5N0eDMHoCc1LtjvI5NKqWN6zuKloz98qRD/vSXwPFAgOQIPPuZ2I1K5bGRJMsY/VDU1fbLwmNoqOYnO7nIiqbZU9IJrw1oax3NdP6594buDTcs5q1E5L8TAq3I4xsQL32h6Lvt8bMZRPqo57K1S2Uze0i7Hp1kAwFr+pB9+gKp/G7uW49BLIwQy0z9eCRd4wxIGZDkEAy8PaNirr0hee0Awb0aW4XGp0wv+Chuxe8AFUamQBL6+/WpnB1kH37pohZgPK+9IJvcgKR7K6J110SOWIrCJAu376tXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 07:32:03 -0700 SeongJae Park wrote:

> Somehow the mails of this series don't have correct 'in-reply-to' field,
> and therefore not constructed as a single thread but three individual
> threads.  Please check your setup for next time.

Sorry about that.  I will be more careful when sending patches going
forward.

> Nice catches and improvements, thank you!
>
> I left a few comments on individual pattches, though.

Thank you!  I will address the comments on the individual patches and
send a v2 soon.

Thanks,
Cheng Nie

