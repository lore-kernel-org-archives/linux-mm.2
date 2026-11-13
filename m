Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6B7606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ERkYyLdt
Received: by kanga.kvack.org (Postfix)
	id 259016B0641; Fri, 13 Nov 2026 06:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2FA6B0645; Fri, 13 Nov 2026 06:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA466B0649; Fri, 13 Nov 2026 06:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9B866B0641
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:24:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6895914015F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:24:18 +0000 (UTC)
X-FDA: 85429862196.27.F940492
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8934A1A0008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:24:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ERkYyLdt;
	spf=pass (imf19.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794569056;
	b=uRv4WuBA/yDjM3/KHl5tgqlQvzynvWYQt+sana+kIoz3hy4XHCcFrom1JUzQzH7aI9OsCA
	Y1JTR1x0V1nU35f/ugusovsY5LjRGSpvO+6X61oDOkaXsPgwEh1SIeUgWNahDzx0VTL4Sg
	ono9ZQ1TjT8VFEnBo9ycfxo5S8ulKUY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ERkYyLdt;
	spf=pass (imf19.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794569056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2z7Tw5DHCFD+mcx9gw6v8Y1X48/h954fhMI36CiU8A=;
	b=T4i+tVoBhTZlbsNIHnebp9ZvDW78Nyo3j/LbZrAqJLrLfzmyJe3T8C/FrFyGI//6THPhMD
	gxAIbQb0/wj9AJFrtq4tf61fgE6XledlhZv1lfbbFkWqRtZjw+EjUnrWdACA+gmeZtzboH
	rH45IqJPlNEEA4UFIZOiQOunZkVSWhM=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso441413a12.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794569055; x=1795173855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A2z7Tw5DHCFD+mcx9gw6v8Y1X48/h954fhMI36CiU8A=;
        b=ERkYyLdtQfVmlOXgevGsmsJ0avMRDJhlEUKTm+2ST2EMYi8f/1AxvbjUR/aB2oBS0f
         C2WPwaA53ErpXrAydv3LNqwnv+RPuByjQnHCp97gXGhH+TsAavsLKL4ZD1TNDhuCuX3h
         LUIiFpiA1lya+IiHChl1L08DPNwiMsBT7y2tgJ1SYT6MLNQlwLOSeM47UzQYvRndjCgf
         QEw1jVLGRhnkoZFHMF8o3Ap5JnMhb4ZEzdKJVfm6qS0Fiph0Ur2UsNqqMc8DDuhi2voi
         d+3pJLR+yYTH2TPSRrC5QqxEOxzSCgMFqdhVPXZtY7+q2k5qRfonVOxQhjAPF92VFS3O
         2xbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569055; x=1795173855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A2z7Tw5DHCFD+mcx9gw6v8Y1X48/h954fhMI36CiU8A=;
        b=s8lHw6OkILWl+6+Y2gr4DtcnSnlgPPb9+XqZPkM3iLgrWmdHSoj13ZH+CGAMoM4Xl1
         dB84O2XIjI90FFckqe3TxW9tEZ7DY2GWF6GRl0UeBrFT6IWVHKjZ00M50g+vYgx+J1d1
         BhUE2iPtjgp9lgNckGjECnSUzujN8NhdxdCghQtNyfraOjJZ6j+a+7gfk3f76ECupwIx
         gsXSNo4RyJVq0gyCjFQi/3m+pfkcME3x5cMr0IfVQUK1Mkx/FjlohHe9JKsD4w9e9gEP
         C1YwcUCSC5zE5qNYVFJOqNlmUiP0vwApfpyBpOKGT3ftBJsGdDoBjAGJ3kHILf0zvnI0
         vAKw==
X-Forwarded-Encrypted: i=1; AL+hErFHafcPi1Y6LvfGPIVBITFSy79klklJ2S5yVveKMhoic7uXOkR071vB+/rovHR9PNqrMPXBPiaxmA==@kvack.org
X-Gm-Message-State: APuU4Z/GGJd4o5771f/NRLzO0OUIYkFXwAMESHMRzPVfnpHYXp7e0WRa
	P1kYiAxtBCLJ9f6LDFPZMY7nR4LeZ3qDTtu79jyPyEG1k4qAFEIq9CkT
X-Gm-Gg: AYBFou09jHkU1ocsT+3o9rmQQPSScwxqV5QxHcqlpaWJJxbc4ByDHn68t+haH7Rctl2
	wdBHZ5g/i6dGrGJVaPmMVhuTWo5F+EunBd5qbkS8fcgmyTTQMQonwPZ2op08eqbwnl3Da+E9pCD
	RyVwOpUrhodCtF9LbknRl1xAnQEuA29NUYHj0f7d15v7DavQ1fwDVZL0lcBF7guWIREhxqBMWFO
	i4RokyIznRv14yVvKkrVKnq7IfX2zXK3jc9zwK0zBgCFfsIp4HZxRtxvpJNSP+l247NNLHRhJP0
	gGTZbxkO57FqR4dpkflW+QMcO7G5TCfvkJGMczARK3rFARHceZJfFdFiTKGkdnhspeu9R/Lq7Sc
	YmlPDbHYnbSaN2ZQUH+bhUjnyZeAPilXm8J0a8JrPRbf31domti/LS9XBhG1yvfyCB6lnCcalv+
	l0iQvL/RtYlyqrvGypQlrg0t/mJQPSqJEAC9Qw0pmzGN+GeTNb5SmuhaR8ahdr2+e1pfAOSqVkz
	82SG2sjMTmPq9CLQqSk1UrGCgWOiojoAmXs1wckl2OUazNr3/ZnVgE68D+pawx6BVETlmmz7exv
	+8v8DBrITv11PGVwNIetctOHt+MEAe5XZsjch5cvGQAq0g==
X-Received: by 2002:a05:7301:2024:b0:36a:18e2:64c with SMTP id 5a478bee46e88-379655d3d12mr2185384eec.11.1794569055067;
        Fri, 13 Nov 2026 03:24:15 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3797f98b9b2sm6771786eec.6.2026.11.13.03.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:24:12 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: mhocko@suse.com
Cc: tj@kernel.org,
	akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Fri, 13 Nov 2026 19:24:05 +0800
Message-ID: <20261113112405.1583476-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avbIL86R61Lu2YVF@tiehlicka>
References: <avbIL86R61Lu2YVF@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1otyokn7f6q33tgosqueum7n35h13ixq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8934A1A0008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794569056-517256
X-HE-Meta: U2FsdGVkX18BQkMJs7L4oryss1mGGhZZAZRbU3TDf5fTLL1lFU/6pz9Fq2T+eWz4v8gjr34QekNPJNbhxh4zHrMfwe/cHzGDQmvPryl+229VrLetE86a9hyja5YPESJw3wnVuLeUuGxkg0heEehncv21eGmtNOJ6gvzTHEcRRWwzXEBHzToCJgSbCbf2OoG0sHzFs0JWvvbNz8OjFzfq5J9m3p7u7BjG1YzOdFyxSeVorGQ06UqYt1UcfQ4d8U5UBKvL714BhsJiDVvoazfPcg3QDaN+pduSJFhrNUgjGNEhU0MoBE1KFsVINhUlc2qLKKcdwxOWt7P7DO5WeE7jsE+Vtif8ZcgS+pqk1Ql1KepqD+jBR2C5e++IvYUPiL+C4moQIBNOEzoTx4CUr3q0Z1/k1nIacRMDQclCcxF3TigTL5iQBMFuhcehlPMB3d2hTPLDVvXzUaGpFrdGHFHsrvy86DJQkm+dBQdZYyLNEYWQktkgPmJ3vU5e1M/zNd6VudDI4qNxTC6hDQfwnsbS4JDmWXGGNK7O0q/yYrobFCFVhsFzwCHQcQIXNIAoZZrgbTQwAXa4sQ/FcDknNh4Eee+yHM8NjeLbnhquhv4+7QhDmk5UUeiQU8ddySlN8Yhj0E0Z4ZHc95sihuGjkm7GOWcTx3I+M+gJ0zaXx0iv8zitZM+5d9eutneOX8DWICp9JJiwHZz4fgJqtjvmuAT7oH1H30WvE5H8i2aaQoiLx3uiBW+JQsZMnOUNVhTT9+R86BvVrr6hk+JEZ/pCD6QaLnzdhovrtg1QhqBdrTspkLHOuldWqBDXbv3iPYlEDM7AoSjGh0tNYpFluyGl2L2np4fyJfUdHNhelQIG9EbTUlpPXX/h/hxB6PrSMZipRNvq7ia5SpMbu+xKSnPe7RMqjFeIK2Ja9iiKSnj+1cD8SivWswr4J/JKCJGp0inoEVyrXsjJ+5SjLNVLa5pX9kf
 YhirIMPK
 g2VYksBvfegczgX6z2Ds9jbryt+O1C4iM8r0vDQT9vZcJGgzI94S6G1NxYrS1DLeha7HYWLVBymeOwyOUhunyxfoxzjGqnNOcRGrz0cAYWmnWrpDyEWWsSPZUr6AmHjpjL9eNLogFzsTR4Ic8JcTZ4f8DMdm/kW2pAUMS9GKa5J7WTSLrgxvRjJbfd21ZmfRdffmCukimP73JIyr66IQqVaGEjB9TioLwdFgMYFxWqURIwwqW7MQjwtQJ93VgFHXdwO0pKyu7Yc7zJfhp06BPT0LJOnQvl0pi251LvFIDDk7j+dONbUtxsAOo2k+QTxBa3Di1XABJVxuqjE1RAc+a1L30YXIFZWCRIqeF2GbrTFqELwEZXiwhwAxxkkWxongzTv+WQpGPHtrFH2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Michal,

On Fri, Nov 13, 2026 at 09:19:59AM +0100, Michal Hocko wrote:
> Do we have any conclusion on this?

No, Tejun has not commented.

The same case has come up for cgroup.kill since then.  da13e0e72a73
("cgroup: fix cgroup.kill for exited thread group leader") in the
cgroup tree handles it by walking all threads instead of the leaders,
and leaves migration as it is.  v2 does the same for the memcg scan,
so I would continue with it.  Chris's "mm: memcontrol: Don't lose track
of exiting OOM victims" changes the same css_task_iter_start() call,
so v3 will be on top of it.

Tejun, if the exited leader should rather be moved along with its
threads, this patch is not needed.

Thanks,
Zhan Xusheng

