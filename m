Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E2D2FEFB57
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591446B008A; Fri, 27 Feb 2026 09:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5380D6B008C; Fri, 27 Feb 2026 09:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374F96B0092; Fri, 27 Feb 2026 09:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25BB06B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:07:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1ACE8C0A8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:07 +0000 (UTC)
X-FDA: 84490413294.18.56A1678
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 804121C0015
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KuK84Pbd;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ka4LtsG1;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf18.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201225; a=rsa-sha256;
	cv=none;
	b=0KpF6Uw8H41yqOXEAeS6/u6dqWZhmD6yKUODbYD0BsLFF7TT4LX1W9VIgkDpY0taQGXY16
	/RZ8m2nq4RQgp/zbeiC+lV9fIEiJ3THhaJM67m3kV75K5076IwbelDduqamKMuF0lJ0lkc
	hxl76uNqCwKVVnsIZXG0n4P9LhV6nyY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KuK84Pbd;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ka4LtsG1;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf18.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QrnGUwS2K/U9l3e6Z5G/7MAq15xmGxokEEu8o3CQqSg=;
	b=nwsWTtNEdYmxRR4BdnzJ5lcEAS3E3K4Qg7jJh22h1yjaOSsHASodCqQdCGysKLkM1fW4/S
	hjaeu+wvzPx65jUnCVhe9mhHwg1CgQrbYFRpLZ9T5PMpowDqm9M6H5HfecPrFkZCdKJj/0
	+BATBL8y9vbGAJtXVbKTjZJOnuGs7Ho=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R7fSZ32308252
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QrnGUwS2K/U
	9l3e6Z5G/7MAq15xmGxokEEu8o3CQqSg=; b=KuK84PbdNBHtRHb/qaLqIxiTLHx
	/RiqNNPVF7n1ODEWqmJiYFWzIW87kBXHIzlPawr3HanrWWLQWM5MgeGhDIcZg2O3
	tkyWgjZj4s/jYSty/wAk817lcnmtV6BdqwoVvz6GmXSLszti+rhU8oubYjVNDqhx
	ZYz7Fl1qkceW4XUExOfvxUM9deOn8Ns3jem5qHC5/2SkB70QI8LitNZVIZLszVPO
	OvkhNYpNEjD19yhZcP8frXsPJicvdJatCSwwUkT5e1dPr6bj5YaWq+qYJFvX+DP3
	paAWh7CElljrmZdYp0OyL+pHc30KgAtvIUnpwK0Pil/kU+uLXlEj3K08JkQ==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ck73q14wt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:04 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d4cf783c73so28715193a34.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772201224; x=1772806024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrnGUwS2K/U9l3e6Z5G/7MAq15xmGxokEEu8o3CQqSg=;
        b=ka4LtsG1va/sogNcYCgsQl/VPQFdvETnYVruSUSIvZImCjEJfTww8W35xNlEDpISti
         2ovHTY1RnEJYkCpWBiQJXKmZG2HRQKzVoXlewEvGGp7+8R2hjquDI+BK0TW4Jp/vxh0d
         gtxevzC7kndL0Jw4TGJGHT9K+HN42Avodj9NSZfxnp46/F/R0MZ5E753J0GUm6P+IzNx
         C8CoFQik1/CkQvgeR4BZ33tEjeK3mLH6AAKsLv30oR0mpQyJFomnxg7zVSPX7QqtCuNH
         O8RCs/lWY3GvP9QVVxx0e1f00wAn434Jesvr04wtyCCzik3O7n+x5oUmAhArW3sWo4k4
         u6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772201224; x=1772806024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QrnGUwS2K/U9l3e6Z5G/7MAq15xmGxokEEu8o3CQqSg=;
        b=jtC3p3LAJ4T9ilAe9/lNTSNIE4OzAANbXZpIfQLER9I4lZQrCeWlvuccBlBnbQYM6i
         id34GlYk4ZV/xVLsTO1NIa7y7XhUgnTSNmM10YPKHZBiBqC3kUvBgyBB9Sd9C2o/nv9d
         pfOclOD8+Jx6LJeCy/A6rXwJnsBaC9MaXtwSeuRT4li6vZGCvus69TKzS7rMBs6BFHtk
         sGhuIhkerW4/fLCpwR5fcmNTQN/BaOhaSTn1x+4LQqLMItY52Ag9cvfNF6Y7htCV0UBy
         bdp8fZ49KBlaMCkFyr9xIMgXgtkMAdHVPgxNAN8fRMbSRhHur/S18gM3akAq5PS69gUA
         5yZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUm1htmQBMeDhoTtXo2ybmHYEwsXs61lqVdNcx7YYOOp/Q0PWaHRAwG/kTI1jig524EbpuUkxAwWg==@kvack.org
X-Gm-Message-State: AOJu0YxS5qjPHxCQgr0FzOtDgrVYG4anYvFkZ3wWbxdJsTLM2e6GctRx
	iCEl+x6WLyZRCEVZwDP/lUxjSJ8MoAoG8wNtIiQ7o931iD16r2ENDzkUcI0mhpRaLtcYjg6ngcD
	kgPaU5kYWN5qzz7dXpfGLu6F5FDEH8uUd53cb61XevmS35qPiF1DlTA==
X-Gm-Gg: ATEYQzyR0sS8MF70J1i30JeAhZufvpHlv9vjL7yYrZZAOY7ADgJRYnl/7OhZ0dBsw7s
	kVJ403fW+8vEUFFdNfl1/h2tC0TazHuz061cXt+yKnLOLixDWVNvZ0K15VZ208De1nYRCMzpHwM
	8MptIgwJ58BhjnUE6V62AnW3FtCsAXHvpvNeMIEvtoDy0RE+UDG4cS3cnqw0TXb5GtNoEh/noHX
	bLUxieAUjOm2p6e8iBBFjalgIZOSQs2vMVgwF0cjiSZEJKFfRACRhGMlYuqAN4DBladyWtXYZXX
	3dIweZtpvXoNIG1PeQjk0jiIpLCpqhCUczyOjU3Dz0z+dKo98rwer69T7qSkKmBeYBH1dNmY7DZ
	aCmKvtjXDpV2KUZ7v51oD+PuKSKEnj1mY6MxW/zRMSB3y+bdxtwuN9M2V9NcHbMgfD/S1WQAGmt
	fUHBna
X-Received: by 2002:a05:6830:25d5:b0:7c7:6043:dd93 with SMTP id 46e09a7af769-7d591b2656amr2098291a34.13.1772201223980;
        Fri, 27 Feb 2026 06:07:03 -0800 (PST)
X-Received: by 2002:a05:6830:25d5:b0:7c7:6043:dd93 with SMTP id 46e09a7af769-7d591b2656amr2098262a34.13.1772201223559;
        Fri, 27 Feb 2026 06:07:03 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866269a8sm4324502a34.13.2026.02.27.06.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:07:03 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org
Cc: mst@redhat.com, david@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
        eperezma@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/4] virtio_balloon: set default page reporting order
Date: Fri, 27 Feb 2026 06:06:53 -0800
Message-Id: <20260227140655.360696-3-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyNSBTYWx0ZWRfX6xglV6wYrw7k
 SCP/tw4us58wcpZKVmYjl3N7+ptKumMr0tl6tdM0a2hbVusgsjzT9/kxnvzPGNmuuZu6BlCKk9a
 Xq+myZcZQTpbHtg3jML9igpUdVrUiBFMDG9zNq5GsbbKkoTOWcrYz4meIy7NkTWYgvz6gSWS7Ck
 5U94IfAqwdFoQYoz3FcwwuETfBqDGo01A7QicB4kT51a1TvTvTZVeJfAUHsfPi+/agLVfCu0Pm6
 /J9R3hqbiuoHC0vA2FOdh7EjXsDH679LhRa9DlN+29lOIWYDQdP5B0UfoPccGapu0PTv+ZNQY9h
 PbrWffRnTqUCQLO+obxb7vnGssI9qZC+1+5px/Bh7ASOPOc+Tu/Um+ii+oTpsMDjjlfLSxkO6gn
 1yaL+mCZucZMiQiI1bPN45VW4buzWEhJdBezJ4n4cPpY/HCkmrZreAbsnoG/wLu1VZvZY1qYoFM
 3zjWizWsUfzUijOoQjw==
X-Authority-Analysis: v=2.4 cv=KL9XzVFo c=1 sm=1 tr=0 ts=69a1a508 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=Jvdq4yWlxvBRgq3Xg-wA:9 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-ORIG-GUID: F4sXcphGwk5OdDkgm5MffZ5C36yCqESF
X-Proofpoint-GUID: F4sXcphGwk5OdDkgm5MffZ5C36yCqESF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270125
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 804121C0015
X-Stat-Signature: igphrw6oyz59bjcu6c74zqhgi6qdu886
X-Rspam-User: 
X-HE-Tag: 1772201225-779706
X-HE-Meta: U2FsdGVkX1/nDIZJXYp3EQmk7ZApoWCs6ulrD2wI+IBf7GpMp+ic79CcNnV2b/GnQ4T+UcwNeE8MxWDw399WBjJPU7MLzqto71LZL5WJi6zEwiVYpt7eVmS1QwOglwWY98TDQROjssa4jL6U6KV30OP9+seAEmI+Wu0n1VqwVcYxrzCnnL2d89CACNZ8pBV2iuelN9NmaVyBDM+XA2REcuUjgJf1pyKrkA49MoVWBb5Liehpr9pfxrc3hU9AcSX0fzz9fs+EyO8H0FTXRpumVR89Z9uOFWjV4RZ/neEibNtNtvNGhKqirJJ8LwMOJdS4Oq07iOmxOu6NKw/iyp/M6IDmlj3tBIyJCwFzCmPxVuLmYs5sY70S7+NAQB+a8nCxrgRcEdNeZCaJDQSr4ADHm0PH6az2twuj+jWbbkNZLS5QZ9JJQuwwOgw2ma0068GFWYEa/U9Hn+hLFp01ohJwDp3fJ1XNI8KHx/jf5s4M7Z058SdiKpGRbQjZ4TFN5v+lHy/RFATdMLQXAxaPqgqAlOa+2VDd2OboiCKu0yyKikLkwHZ2woHmKC3U3jSAa8FYzcD7E6GwYmH67zWZCD6d3Tn4pQG1zQUGC3CCjP3aEUlJlbdHHr132xVZA+JsB0SElAntAv/r5ku98phPJaHgkOlKcPCqXqoIJyxQIa7FvZy8yvBnWAj4rqz0RWGYq1CTkOOoMRcaaUMBC6RjK+QKDRw9rcVvztxQUMgyylSyUXx01GRk1HYgyeeg5Hg6I1SAp9AX6b9BRTCqn5CSM6rDZhg3zku09NLy0mreZh9u074xJbvBpikBCUsR2n8ujrlM+Itr7roPzoiWljgO6N6TE66MW6h4mZ4i7NKzSYib8eB6PbZjC8nxoaKN0hQ/njL3gfsOrGBOgcdUxeozsnaZX8vfdSCSaSo+BxDd23LDmPSO9pzFbioEBqTCsC2FNCRbSGYyN3Nzn2vsOyw4us5
 Irlz+rgD
 GAdytesJsKBk+nHBBdEHuJIsWogQAUbKJWBzZj67UcVHkglx7+/1VN6WCy/h+Bmc7Ee7QETM548MmEpnxA4D2+s9oBAWmCxUXUn1sk8bgCGibg+7AkmapEcJueIyTN/wjEgtSaAgr0xinogQkoWKGAyuWJiecaQHlYgE0MpNeIe6co7RfQiiok/xU2RCo0eLE399wBUjzxJcCfTKqFPgKfaL0FZztINN6ZZxiW1LVnZUB/AASGQEoPEx2JrOrTJvpk0RJ9tX2Lh6xXLva3pp/5gD2Sbg/NDvJ35M10JE2L/juIBgTkQFQtwbBg5yItSr24hLTQX6zWm1S8Gwnv/DIqdsXpwT14DoL0ZpSJqfk2RCSZ+D49LC6drGDajQryyh8E9sqCxiefkmd50geaJAnY9erBqs0svXAcUUx3YHdNc1B/JBZCD4+9Nd8bh2w4NCGJHwU/nRukRmvaZdRBvWF6B1tJY1Sp8Q+AI/gkER3kO7Muh67SN8/Ds7I0b58hX37siFfANIVNuTe0WMxF6X9KhIEEwJXBwmqHvlZURhMEBi2JY1gAYBx2iXLpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

virtio_balloon page reporting order is set to MAX_PAGE_ORDER implicitly
as vb->prdev.order is never initialised and is auto-set to zero.

Explicitly mention usage of default page order by making use of
PAGE_REPORTING_DEFAULT ORDER fallback value.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 drivers/virtio/virtio_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 74fe59f5a..0616c03b2 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1044,6 +1044,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 		}
 
+		vb->pr_dev_info.order = PAGE_REPORTING_DEFAULT_ORDER;
+
 		/*
 		 * The default page reporting order is @pageblock_order, which
 		 * corresponds to 512MB in size on ARM64 when 64KB base page
-- 
2.34.1


