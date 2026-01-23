Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B62D8D6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2796B03B9; Thu, 22 Jan 2026 23:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7C36B03BB; Thu, 22 Jan 2026 23:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4026B03B9; Thu, 22 Jan 2026 23:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4561F6B03B9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:57:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F1BD1A024D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:52 +0000 (UTC)
X-FDA: 84362021184.04.30DFC30
Received: from mail-yx1-f65.google.com (mail-yx1-f65.google.com [74.125.224.65])
	by imf20.hostedemail.com (Postfix) with ESMTP id 242D51C0003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Or4PTKl4;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ4usUMGfNo7J4lew0QKMfQ7VuYcLUlFI2hm5aH3MjE=;
	b=S7XxRYDSg5hkh5fS5mjp0IDMW6TRPvAzgdJF9Q15dePSs1vuGGDoLA62saKUWW+PlzfOxF
	KIjktiaTtG7PCdFjuZxxaX4AraiemQuQtzp954oAT53QReHDeEHLAGyGRmut+S8AbrT8Q+
	QwiMDHAWEE/PR+lL1zOBB8/NKNQ2ENE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Or4PTKl4;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144270; a=rsa-sha256;
	cv=none;
	b=e8PHwXqywi6OxemIJpTJKDsat8AWdkwF1dZ0r8NFy9K4aIkZbzNkJvcW7qw0KuPhav/tc8
	N1n9e2dQIBxRr14MOnp1YXDCvE2Z/gai1vJaSFBF+iQtyyBtkB3DgRn58NmYw+K5zKQLS9
	V8b3tBhaafoyDN/hpqlTLJvXJm52G2c=
Received: by mail-yx1-f65.google.com with SMTP id 956f58d0204a3-64931bbf70cso1667903d50.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769144269; x=1769749069; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZ4usUMGfNo7J4lew0QKMfQ7VuYcLUlFI2hm5aH3MjE=;
        b=Or4PTKl4rZTEXyHg3q2GbNaFhlGAQkX0kS9OcxET+5DcjCiLkcwFPGDnqlePgUysHZ
         G7hMhxXwp6/mse+Hamj9Kf98E81+0RVtsD/kT8KNVQy5njb6PkQiTC7EZFtdIIv7Esc3
         Fm2qcCRBhmWok1PxQ7IBg1K9Kj4LvySisbsO7nWApSc9h1YYIF/doLq1qBfPwZeQTAP4
         /Eoub7G24CHF21QG2DdgGr8OM2kvRcVomJSyFa/CSr6+c9ofinqT1EHliJKWMgcy/eVd
         raMuwG7CwcsSzvP//mWg2A/vYEt7avE5p3zhDaLh+T/9cLEXQMEiFCd1xLsvjLND1sK3
         VUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769144269; x=1769749069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XZ4usUMGfNo7J4lew0QKMfQ7VuYcLUlFI2hm5aH3MjE=;
        b=e4SJ7xBSGP4Z1MHQh/e1fNQaVHZ3p1Ti/geH1xemvFIzQaaQ/Dpa4u8dZmnFynS865
         +JtsKSx0ZLdeXfbuOaWIiCi1GTfbhIXLrOdTnUBBNls2JscWhRljyAk/OXovr3jhZkpm
         a5fnnFl3AgkhaSZ9GxLJyeYLc40ovmtdH3x3ny8vLm/RXP5vWGSj4oJCvc/0IDEUHBCR
         LXtuhi+01nck3tcKpzjmO41y7KwaWwGT6qalx8rhNxCpKDnzT2vjK3KHCfBGT0Po827Z
         HDTGE6gUU+mEyXV0phGOPPx+08Ew29VoQVq7ZzAkY8uA3DD5eERalQAA8daMKXnliqPx
         2R+w==
X-Forwarded-Encrypted: i=1; AJvYcCVxW22cpfD+7X48ChUySHU68NxcNgoBTt6uGydkFt2aEOcyFWQWz6jfMnQ1stZe1G52bYrLmRFKsw==@kvack.org
X-Gm-Message-State: AOJu0YyerIZ5Zz5BBUtu4MCT2ub+5DqsCNarvCQKez5C5moTG8jFZlYe
	q/JX5vol0BVsX3yIdlkwQpgu1CEu17cRf72y1o8pmNO2in+/nbn1xTo=
X-Gm-Gg: AZuq6aKPzyj1XhqKaBZKNFFUmR3Is1T86td2tWI/sao0kiFLmmyTpAJFfzMEIEJHHlJ
	wPwSxF+09YdqogWQ9ToIGb/RFkj0hMYXhIHRvsqCPapfWLjX//Q0TSIzPoIbEAoFC/wbFIJnkcf
	EI3912I5DHKD5MhrfddujaO3b+45oBLf9hZVQlIBoo5lMgCKby1L1RVgLrDwQ6/B/mjrZX4HFEn
	F+3q2PWlsTqIR6QMUQYsQfGXm3u7coTXvhVMWvGfme00oIu6ZSciHCfJFk9b08Gk7vCwBVul9Y8
	A58Sg/98sJANX2xliK1BPRXE+/+QqPaOlYHLD+ngzQbk9yWHGP+T+uZpZk9qrgDmt3YlZN+OtZ3
	x2hq7IyKtK6+TC/wDJW4JlvV5oPH7o2qRRIJGajv/8LiBwiqbQrxfdJubxV22l2Cb9Im4aO1Ijv
	X3ULnfZbsMW7n7Dz6atKIxQAg1MEg/SvChR8NriMCaeICOBC/45o4rUc63jMo/RQ==
X-Received: by 2002:a05:690c:9693:b0:786:5afa:375c with SMTP id 00721157ae682-79439a09235mr29912047b3.67.1769144269171;
        Thu, 22 Jan 2026 20:57:49 -0800 (PST)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7943af14427sm6466517b3.12.2026.01.22.20.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 20:57:48 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH 5/5] mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_metric
Date: Thu, 22 Jan 2026 20:57:28 -0800
Message-ID: <20260123045733.6954-6-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123045733.6954-1-ravis.opensrc@gmail.com>
References: <20260123045733.6954-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 242D51C0003
X-Stat-Signature: w87azz4h49fjoc1nwq847fu7khe8sggi
X-Rspam-User: 
X-HE-Tag: 1769144269-71036
X-HE-Meta: U2FsdGVkX1+oRjRiqk2kZmdh7aR2ME3SNCCSWe6a/cfaIIxue8+udlsWekWGwZT1MRA83fJsk7ZMtxuiHPl3H4PiMWHTeBhegy2Oml3Q80m7Jbec8GW9cNlzcjPjOx7jXU58tlPjrbNEnK+/MkDhGvz6IHtocojl3ZWCmYgKwoK3j1lV1V/Cflh6or8qOuadK4GF02yXQDB4LHVgoh7101k5WGzHyOkkAucLU3szVMv1FR8QKYEP0uefpjkGsQT3lgg0Zf+iEzVTAtzIGbmO7iCjroLGwCuCo5MO5TLgVQLtp5noYYPKmrA43+aWCWUvdw6+wF7YNc1VQ75DTgRmmtIx5B8KKLOVXAS8Br2wIjphMV1GzvTxsRueecAtFWCejZze3UoWxRiLsS8AcCnKK7UGw3rvfOwOsakk6cfMgNdqGiksR3zzCrEsQs6EJSgyxtJDUFJwcLo7lRsgd6tuqoYRE3E7s2hUZynwsCgDgpdY1us0VVNBYkr4s91jhWKvtehhLbpmtPxTnjiUsKHfK1morzPWAYicnt5C/jLjsnAjFeDzHziDOGhdd9n+ujVQD3nK62ueGCYBcUlinpMc+GRtTBGiq1NcB6x3CdHzVcrA1UusxJa4vOik7+CvNkY7BQvr3XkrjM8I+Kt9z1volee+O0eus2bmQIjmZcxB82uZpeqWqUoJ4uno1SVNDL8wDQQr2xKuG7eRDQHGVYsBK3ITeBxJwLhokii76QBm6KQXBaxeAwkuyI9t6wcCGjQ7kAJdcsYEszVJD4Q14SjER07gYok+AINzTksS+K5RRvb9FmeROC9XTgBQM9o8fa6bNHSrj1i7TRqABghwFv3laNzXgCaihpGwOW6Qxh4V3Vt3DZc0L+uueMNsHU/6xEBCHxyU1fEvPJMjRplIeF8nIGS8V3bolV+PGxnhZKy5LmQfsF8K31POGgKeUn3fF20zU4zfH+U6lgnyrMQi+Fg
 qrCAo25A
 IlTgD9InmbtQC55Fef6zcxz+Dvk5Y+erGJUWS7S1F8yB9uhRyumUpLJ51A13A5dOYFosAFaIw30efMTqQKFLifewd9h/wyKBlLs3DAbZHBKWdWuceG/UEBTW0Dphm8ZOOGOKV91LkULXggGLkV9pQ4NjrPSah5V2y3TQKcEdn/bMBJoOEXfN4YVS8U/AXLatGwvQRS3sY3iL/SmA0TgGeh41mthO99F0ut3Iq6B9MfSs3hmG/yshiFkQA0esZaU/XFsrFvwmQRSVYCYBcPZ8cL4EeENTXzZ5Gha7CSPzdhPzLTUTHRK7OKbHduMy6FJT550ztuKXNJxYymryo7Dsbknh8v9W4+SNINXhWAljMYz/LpS5+HLWXwYrNwCrBxF9N4BSIQi64+rV2FlbjQGm/RKFzJIz+QfCJhnWZx4rWpK+4dKrcUOLW9WMzkY8umRNR1rKNugLzCPeWllbZJrr8jo/UT+8HIWcTzc4Ojq3irkGlD8U3vhmMu1khoNg9WVZBU+KCnZ7T8fBIZynwRhMtSZRcUT2I8FoTGt8L3pY7HXrFhHcfIFKeb6TrCkrQZ3lRlhf55Z31sptR8+ecQTEx73av30uFuSFqhpR2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow userspace to select the new goal metric "node_sys_bp" by writing
it to goals/<G>/target_metric. Also set goal->nid for this metric when
committing goals from sysfs to the running schemes.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/sysfs-schemes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3a699dcd5a7f..37cd5d715821 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1038,6 +1038,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 		.name = "node_memcg_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_SYS_BP,
+		.name = "node_sys_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2566,6 +2570,9 @@ static int damos_sysfs_add_quota_score(
 			}
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_SYS_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
 		default:
 			break;
 		}
-- 
2.43.0


