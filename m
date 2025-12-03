Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B303D12689
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 01:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BF36B0005; Tue,  2 Dec 2025 20:16:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCD56B0011; Tue,  2 Dec 2025 20:16:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2526B0012; Tue,  2 Dec 2025 20:16:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4E96B0005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:16:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA04058BFA
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:16:03 +0000 (UTC)
X-FDA: 84176393406.22.A7DCBAA
Received: from outbound.st.icloud.com (p-east2-cluster5-host3-snip4-9.eps.apple.com [57.103.79.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id D224980007
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:16:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=JkH6seBa;
	spf=pass (imf30.hostedemail.com: domain of alboodalamri13@icloud.com designates 57.103.79.52 as permitted sender) smtp.mailfrom=alboodalamri13@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764724561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5tWJUJG6SnYBuBZeZZq8cJ7glHx18gRawtEfzjWMsRI=;
	b=nNuGYgnjZutGw/ZgQRvN7AQwZgwVnuxALv+mKCe8osAFn68/OWkJ4uE2fZSkeflrrbTf6z
	51014kr1vgz/RXkvOY1fpSDRbas1VINLanQLyg+e15gzkiUzMvauS7yV9dDIAJrDuKdby2
	4YbfboZsldZeUc7tPp8Yyq9gVLfglHs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=JkH6seBa;
	spf=pass (imf30.hostedemail.com: domain of alboodalamri13@icloud.com designates 57.103.79.52 as permitted sender) smtp.mailfrom=alboodalamri13@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764724561; a=rsa-sha256;
	cv=none;
	b=JBUCnoRgG43aCC6ZjoIx7GHTCfr3s9O+vTfKW22DjpnqGgCg8z1eMRUOIGqLommYy67A4w
	TcwdiG1EAdi9kB9Nhcftiqz3SIbThptAM5pXYQMfaVT3AzOwYNOE8m0YpPwovuSdV1iwi4
	g6W/gJOieLZhOVWLSAbaBr16HsKBxuc=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-15 (Postfix) with ESMTPS id 3818218001BD;
	Wed,  3 Dec 2025 01:16:00 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; bh=5tWJUJG6SnYBuBZeZZq8cJ7glHx18gRawtEfzjWMsRI=; h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To:x-icloud-hme; b=JkH6seBafZxmRVUdqc3Y+w/lZStjRgzre3CmqC5FHW7oU2xRXWeyjA7HZd6I0qd6Ewa+kwC6VjyH0rOEXwZ9HihSzTRDDCb0o0ox53/njNu3gwO1drb8Xk3WysoxUNfRzwIORbMru9cAUTAi/VuQHez/h4xji/rsLsuLC6YYzjtB7PqKCZIMcjkt2bvoHpkHhRkioVBXKgCy+Hv0kqs72RSk383rBZyckO1OOBZB6i5c9NBTaC2nf3IjxBQrO6on7dBfoV6hEmWaJrfLW9nHQZzw/5A4JVjE289m/OkoAPZEkP42w1b4Y5lm/ycr9cIew7iu8CPLRBvj4/vIR6WrPQ==
Received: from smtpclient.apple (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-15 (Postfix) with ESMTPSA id 742FF18002A2;
	Wed,  3 Dec 2025 01:15:59 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
From: Abdullah Alamri <alboodalamri13@icloud.com>
Mime-Version: 1.0 (1.0)
Date: Wed, 3 Dec 2025 04:15:46 +0300
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-Id: <FE7FB0D0-6CD8-4D1A-90B5-DE5487E378B3@icloud.com>
Cc: James.Bottomley@hansenpartnership.com, cl@gentwo.de, david@redhat.com,
 greg@kroah.com, jikos@kernel.org, ksummit@lists.linux.dev,
 linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, lkml@metux.net,
 netdev@vger.kernel.org, tytso@mit.edu
To: torvalds@linux-foundation.org
X-Mailer: iPhone Mail (22G100)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDAwNyBTYWx0ZWRfX0CBsIh7m/AhI
 FhNy9OzFBRQ6lTdilYWlw4niVyHgZMB7p7sqUjhg7sYgMXFbCpcuXUkxXQP7bUNVhQT5A4mVhGL
 aTDsXoMI94SJ3kbKufVDAQSNfd29YBw1+3dDV72x2UvvDWI7Ii+VvoDbwpi3/xF9TvBId2l4+Rc
 32t58DeXW9SSJ/VpkJSZ9cWKen7G0nJ/b0JoTZmImWFe+ITLPO5d3CRz/3zcAlEc2e6DJvOhwl5
 MaIfAqOUxAn65qV7sN9zyYXhUDARNcdYdedPQSS8PGC5F7HKkc9GAaXBjcYDRN2IumQS9Dvdnb4
 Enc7JD+t8mfq2shPGrT
X-Proofpoint-GUID: es_qhwUAhhCMzL-D7iYTN7TCo308goSO
X-Proofpoint-ORIG-GUID: es_qhwUAhhCMzL-D7iYTN7TCo308goSO
X-Authority-Info: v=2.4 cv=J5ynLQnS c=1 sm=1 tr=0 ts=692f8f50 cx=c_apl:c_pps
 a=YrL12D//S6tul8v/L+6tKg==:117 a=YrL12D//S6tul8v/L+6tKg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=x7bEGLp0ZPQA:10 a=-KdL-90ardkA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=HyzYxv5D6p1NO4_E8OwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 mlxlogscore=666 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 suspectscore=0 clxscore=1011 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512030007
X-JNJ: AAAAAAABcBUMmKYEjepPQWO9oz0fKF0xJR4oEUJJJhwb5ynuO3cAT5TqKmi5gvBxr6b+Pia+G2rXYHxNYB3vI9ZpznaL1pqVzmaGJF23x5psdUMBBcAWXvbSTGq/VJOIzbNDcy8vftXrsq5zR0BUygpb0/6VN3p871Ph1ut7tgYelUYZQbdXnFdO25/QKR20Quhjct26nmPnzwIIBPH1w/WgvRsl8hpGxnZu2szp3h9brZwli5v/9Il4K80B/3AtevYJChN/GIgKGNHAwMG1f9THHkrw2Y4+BIofgjwEtO46FHwMqkKmnmOyzHlJZIH/3WTRw5IjXHu9sGIClaXy0ViVT7lKpO2qytvQ9oRNaL4nwfFlRyS4jJOXayBnbv4WOizprxRrfZRg38cFMgKpEpdv/Vy7radCRRgdmGUcT3/tK3QDaf/H3CretHZ8k6yzLy3nhe20SzqVdzLDgSbwGeNN1JXJEJyC6uy/mQZ8xUOHGyWCnotv0w+abcoO8WMeTx8UJcl7HVhlxcqVwqpFcQqOzf66fBBzfoljzvrzMMlGk40i0bfOaU+xJgUZUvcgZ39/Bdq/rgCqzDsX+cNteNdYu8GASjdLKYaWgQ7HGzuP4BT/BwYgsyCAKh5eBgaALzV4CWUO2Fq/fu41Ha/Un+hrqWh9uETR7L5XM7++iFVl/jqr6WBvVXgbpEgzltgVgUeUxkmmb4cnFuz3BIaFNao4OoW9Fvuyu+tw9rHyb8qCGWmrNuPdEr8jmBn1wDyexpk4Lbo7ENAdhWx9phpMfvTyBpIgW4WFtso=
X-Stat-Signature: 1axahemwnuzgpyxawe8np5yx5hagdrcn
X-Rspam-User: 
X-Rspamd-Queue-Id: D224980007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764724561-975602
X-HE-Meta: U2FsdGVkX1+oGe7Djwy3+6GO6zd6wQbjl4BpdYPbXcnXEuPrWYg3E9SVBoxv0n68MSqVqgRrwIgJXoHLWhwmE8rtAdgQU5OILjE8ss7g64PhnCuGd5P7Ltf48jpliKzYLHhbQ1eI4HM9JsQgE4XB3CIiknrrEBFaawPDhhp92gAF9fv88DaRoxQUDrHQrOaMBif4W+XweOF3j0RTmpiZpx9h0Mn50MNBm8FmNuftaESEFBRItYdclPTD/vvW7JrJiJYn3k+Y7O+0zUrJyo/xL7jRpM5T7mEnXSt0ttUG53W11PB5d8pYTdNxlK5adspikBj8fSeY1+Ox/kI1pb9sSE0QX4oK8jsp0gx1ZJjd7NBKR1c3qOUIwKnSxx2LTtgseuilY6dTC7l1VF73spnAWCu3e6zr+iA/cLhJGfTu77XRD8ZhwwHonShFW3ynNuQzmEDJhRX2XNShN8/J/nN0C8oX76z4gVkYNlMxwuDG1VHym7PQye4OLiUoZkp6HXijrNfPFUWT4A3qp5L4LTAKxhO67SHditJnNSQQjB6RBEcSfXwXtP4ToZ7PVTjJtr/R3mHWJ00F1Mcw0QwHkLHaR5NkwzaJBhipZ01wxZbaQTkeyD+jQCNegX26W68KiGKcpfBnXE5Tf/bpp3OvJGA4pxqPcUF1rSkkaOzqEbItGXptIDOZGhpK8TYold/brGBcrsbtyYMvg2NqW1cVfI4xiF5p+vYLh7H1HMkmXrA2GS57duO5qfJTBw13ZYZ/S31PeSnEo9jvJCQ72b+OYyAKLiTj8ZezgtOdcJ4ZdWILXtx8xEQmPPPf0jjQOUom/wT11RlvOrkgFbTGhcwMf8qsB99mEAIj1Tl0cU+Zx+QUICJMCLXC2pDQyu/uL+WXGY0OA37MEff7fS9Q3EaFkyvvPJCvO2gwkcs7G0/mXCJlQuIyhGMSql6K1oy1Xoo5sZy/2n1TwXFHRD5evZuj305
 X50CKzb5
 BibSLfPFMvgFe58HFd3Du+9qWVv53HO+3d27a0dlFvd2PzOKu8qT5aRBbkLsXRQpnqpwqYXhS8ebBTslzTJyDM2kMU2zS/vcY2zxagRS72xW1nhBWsK7beLmxp0otkGYIbZ1XIc4neOrQrRWPhLAZ3OBGynaIh8kvHq+XK6TBxdVkk+wrrAIpn0RPnpmSB7INh2bWV+5HTj3LMgk4d8gMXeDO+E90pKMZe1CT0Njocm7EBJfwe9/3MU9TxwLYIfX9wCfYo+bHlD6+XXoaotMmxighSmuGFx3r/Xb9rIZ6EBRG9RHiBBdOZRZevy6bXF86uoTpndIPCGq1N0pWWrwA46Nq9YUpgdJWhT8eo33V7XqP/RWVko3eAhGIMxHAQD2s5uRBVj4ljV4OtkV/tXZlo4EOX2QeiLyR1GWs/Jnaae+64H91YckaJ+eYKiRI+rGTcMg3vRw2imb8szb31jDmBBKNk5bSM8TAxC9cUkG3VS0hR1IIodTf9lexYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.140801, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQrigKvYo9mP2LHYs9mE2Kog2YXZhiDYp9mE2YAgaVBob25l4oCs

