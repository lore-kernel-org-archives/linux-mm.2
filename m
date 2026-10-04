Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C47CA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 08:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD4A6B008A; Sun,  4 Oct 2026 04:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D546B008C; Sun,  4 Oct 2026 04:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2939E6B0092; Sun,  4 Oct 2026 04:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 063F56B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 04:01:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 040CE40B0D
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:01:19 +0000 (UTC)
X-FDA: 85284198720.17.8057D9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 641D580011
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:01:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bV2Oz3wP;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791100878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0bhkDeR0q/RIGHHdpd7D589iSN3oIrJp74cDlV3Lkg=;
	b=UXxBc+CzOBIjoan5QgwhdkYTWblfFyoINUbMdvyztShYSOfhio5KDr3HumL1QEEdxagNI3
	QKa24Rsy5XXbHtYhx6K1BqLdtKpW0b2IIeEimKNebOZD30eGtjHGj/z0lr4W1gHys4yFG/
	q2UFEXFQfiCskg+ZA3/XWMtaJ2E7cIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791100878;
	b=0N2e5nqfyFZSvHJWTA96eq4yXa64F6mgl1wz+VgJ8TUwxyE1+erg8QgjTdZUaOhlGPBUls
	/1t496LNGMQW8DdkJGexThKguMgIROOa6xB0ae566jiJH8xfS8M5qz59OwrUg3mhYO+QjM
	IdoLYJO/DggdUIQvZ2znq2h3eJlpE58=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bV2Oz3wP;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B4A860120;
	Sun,  4 Oct 2026 08:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D391F000FF;
	Sun,  4 Oct 2026 08:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791100877;
	bh=p0bhkDeR0q/RIGHHdpd7D589iSN3oIrJp74cDlV3Lkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bV2Oz3wPh9CI2vgAGfVd43hYzt6c1uvlk7ix0Dq2MmknOdhfzHxfi/W7w31THvoWE
	 ebDtjhVfvO+acPp+9yL7RsNOL5Rnl8eTDIO+Fe1PPIQN6rHL5hOhIDu6621+gzqlv8
	 H83jxW1Eh7YMuhBvyHR7p5n+lW2MQhJ5AQ04Ynrvyg6TVqawhuYYm2op2HCUbhR+H2
	 ADXlY4fPPr0KuKg2w4ISnUM2WB9WJk9Mi3a4P8GEh0YgdiHnq8lPBivxcQSSUJYM1z
	 iVyyKP1HFEX+iRR952RqoePaLSF7/UVXRTOuVV/FT7PJh4eTrM7eD2LUyNM9bh8SmF
	 xfMmHCv1XGaSg==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
Date: Sun,  4 Oct 2026 01:01:10 -0700
Message-ID: <20261004080110.37328-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003202727.3673-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 641D580011
X-Stat-Signature: mj8pckpm55mumjyxax77eg89s1xt3tp8
X-HE-Tag: 1791100878-672595
X-HE-Meta: U2FsdGVkX18FU7O8ufTqPHVvU+jUhzT6QuaVPEFQkckbpvtBXPWzSm9pjkfsW0HJdnihWlWoAW+T2Bpq/r3XwfyHc3fux1BW+GCM+nXAnegKTkPX2fIv/Va7P3KDYJbwtfdp/rdDMWpFgm9a0dUlk/HC1AZn2wyaVO4O3fV9ROFOEBCp2ny9OQYQrWfdl4cPiwX0GNQzmvwHIxOvvjG4dP2stXx7my7weBoEBZK7OvxaYromZlZy4b9/0/QC8lnUHXG5PCoEuwAz7v/RhfyyJD9wN1JgyvaTJ/nsE4yp3QLXndYna6KH9ERKinFFUCTTFASPrkOKLhR1+XTsjEz4Pcr3lTk3Oj5eLKixLGbWUk3XKBnLAeCXpGO4Un4IpWu4qNwn6o8zHKISOZIVitby5AdMsVO2IpChFHly7P2ZUZGXV9cok2FXyoXyxC6kATrTF6MugJD/1kfyRBHBZ0qw4K4tFMaOLenbjFCyEHLGfyx/pBbgEC7AuRbLG+Lxyqkhs88YUxTANsv4wgeObVIHpOznVdMgyZ9Yx7uMPPbTHmRafqyb72+z+AsaeeeKWkNVvhM1hh6Kk0OtjYwa6lwy8t5umElRY5EPBbJe5Y0NaNpc+ihC4R1RqKJ2pze8XoaoldqHXoSH7cGO3hK76j6fa9jbD79N5Hv9vTJQs3BiR5GzlRPu8NbfOLZok980rod+Z+haHzPreb3y00FPTFA3lL46CWNJzAk+jtQevAffpom8tV38041pZNpJtNrs0/P9hpo5E3mOOnstH8UQHy3V8QABeUtLmXMEzI07HqlMQsf88AhtS8aTDbk7ZDs4JM/Ptvcd9ofdvqslqTL10l5fYwX/V4Tbbko+XQEHtczWdmKEYyyVQUK7zuNFiFJwA1NxaHUVmn2dyOCFsMnmKYXv1Ylx/MnLEfoDU5M89AOkgyqbgsdtqsb8wPrvCZESzyBSKxaB6IhQZuDgbXy+GN8
 AD+3HYHh
 tUtBsD2r4x7sgd1MC06dsupgqANiIehDouWwYDAgumSoliugm+ft5Auz2WBrBePgTEGm5mI/u7jDJz1WMnXC+JokEk4FdWSOCZQu9NMxdn4tj/XgNfoNfGIgqvUNeIWR4/yeke1jvpq3Mw3UbRMZUsgWvxzziH9hxa6XnHHnM1hIePyJNZ3y1PDlGElZS7TDQoP5cfJE8qKYFjvb5sHzKAU/bezbWop1DKGY/MgLRM58HIZzaG63rJIWOsQQqLHLqSaYq53GE5c7VNqGLPnh2UsMUrpWv24Q3a9bZjb12/URLtugKEoWT9+ffqmJJwqwUOUHyeqmolnSfQf3abFXxc+U3DCVjZv1nUQhl+zVTp1tR1gB6Vyem8x8M4PiLSlQy6w2LZ5GetxFUoTb5KffKRW8GQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ravi,

On Sat,  3 Oct 2026 13:27:27 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Add a tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP quota goal
> evaluation.  The tracepoint fires once per quota-score computation when
> the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP, exposing
> context_idx, scheme_idx, nid, target_value, and current_value.
> current_value is reported as the quota tuning sees it, after the goal's
> complement setting is applied.
> 
> The DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric expresses node memory
> occupancy as basis points of eligible bytes.  This information is not
> exposed through any existing external interface (perf stat, /proc, or
> sysfs), so the tracepoint is the only way for userspace to observe the
> target and current eligible-memory basis point values at quota-scoring
> time.

Thank you for this patch!

We have damos_esz tracepoint.  Have you considered using it?  It doesn't expose
the current value, though.  I thought it wouldn't be real problem in most
cases, but I can show it could be problematic for node_eligible_mem_bp case, as
the metric value is not straightforward to see without using DAMON.

If you really need to know the current_value, I'm open to add a new tracepoint.
But I think it has no reason to make it only eligible_mem_bp specific.  How
about adding more general purpose tracepoint, and/or update the current_value
file [1] under the goal sysfs directory to show the current current_value for
all goal types?

[1] https://origin.kernel.org/doc/html/latest/admin-guide/mm/damon/usage.html#sysfs-schemes-quota-goals


Thanks,
SJ

[...]

