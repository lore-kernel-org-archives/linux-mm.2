Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9621CC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953AD6B009F; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8418F6B00A1; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C626B00A2; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47BFD6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8E271202A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
X-FDA: 85036864794.26.1BFA805
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A39F1C0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmuTp6v4;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9iQ2CUL5Rc0Ka6RGKfOqCWa8tUB1pFEcM1janT09BA=;
	b=tnfHIuKXQq64ISOXTtcPCAU1uHLqvGkDIazOVUBb3cf+zEQ0JjE/ifFzMgQpVWnB6cmi2V
	WCLMHOunDapObn6WvyM6a9pLOKGVD9tUqe+kH7QgsjU7syifRQ9hLJbTZVNYosFZjuWK7x
	CvfDEHDAEaIoihQVZWM1ZRjT3z/bpRY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211976;
	b=ySJS1GRt+hlH2VLzYm4ZQdem8pha5SHTI+rrptWFi1g7X95NcBo151SNrMzP25xgNxFXwx
	lH18cUGOZdUa/vt+ylq6e5L4S/R3JHLvKf6jo1JmxpOuaUo2Vi776u4SP3qAxBMdnjbCRi
	iDww/KzfPZplZSAMzWPLnNpuL7AMoBw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmuTp6v4;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCA1360A74;
	Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC951F00ADE;
	Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211975;
	bh=S9iQ2CUL5Rc0Ka6RGKfOqCWa8tUB1pFEcM1janT09BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmuTp6v4hITtNNZ/2H7iOuVZknyvn6HDGNFqlPyxe+Sk39i7lAGnLEkOMq2XFHQwc
	 dlOdghpSfQarFAowtN02qH9bLYT51RisZ0rDUEQcl7/cPzzttuR+/ny0DqokEaEHct
	 pO6CskHRh4XOYrItT35/2HC1QnYcgbOmak1JVcN3TFXxLaN8afIgc/ZabAfZXITpxU
	 /Dr5DrylOm80hZ7zW56r5wfcvFFeGSMwfbV9BmVazE7g5ObPul6k8UFSIthKn8DtAM
	 fITqvPUW/5AnlitXk4T7uRbQIJS00xglF0O3TvOd4HzaM6gK4PwBzsttPNSRjr+UnI
	 3uLps0I0Er9bw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 10/17] mm/damon/sysfs: implement preps/nr_preps file
Date: Mon, 27 Jul 2026 21:12:31 -0700
Message-ID: <20260728041242.187380-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A39F1C0006
X-Stat-Signature: h96ncfaxn3h4enykc5j15p6ncuyaas56
X-Rspam-User: 
X-HE-Tag: 1785211976-165612
X-HE-Meta: U2FsdGVkX18IiKM0SQ9xRDecLK6JQGk+QIVTatULxLk0Nie+Adaxs4YfBfnrNJ98nQeRr3/bbwr7KItl0dNUjFZNYxEfde5wQBaBNM78QgEA28Rb9WQVRNtDbOwwBQSDDa2RF3zxh5+AdEPVaGEYkBNfNKTnrtHR9WhVNbU+pfPw534OEfuIV+ISXK7wnUs6/QvQp7bdcG2VdB9LPVVfuLTPhFBqp1PAKoybRZwHhDFqVo46le668QMcJraeQGc+tKkuqvIxva5GmLCb9G4ArpfDFipp+ejxyAzqYAbRCGgSt3xpKKhqWhDAcUuR/LpKPZe4Iw1ZCZlCIEGYBJNE6+6XdsGyTIGqLKnp5HR8UrdDcexpHz9O4ao8gnSSfzRuEzY7KwYi2SY55L+1YOZvYVRcwSt6hb3raP+zhumTRCkObYp2O9Ws1a8iMU+0W7ev3lomQz6+JzsWdgLyKOyfD50t/rD+M2f/qyIG4PwCC09HjbDO39umAI/zfZVbbwQxgoO1jZ5G+hbzxBAscsJKSNiYK7YeBTRUWiZvuptu5GUBjjB6r0qdRsge6d9o2h2nrqWykscWKT5e3KL5zn1OTINgtwNRTdS7KK8KkV8BGm12sB/BPiiUue4jsn/O1+GQsszAD4RA0XHu1qz9PxEZnRdsiUt4Jx5lamXvIIkz6OxPt/+K8uQJwIn9no6TVNoKhdCDIE4Do+cDO+yTYlHpQRHavr6JhPAkEFjr1qoI+iHhgkswDUaDqQ0Bt2JMo2U1689eRnM9KolPeybhlRvxtVmlhNMyGMtdmNCdTOxWEcrvdIUnfK2As8Nh/ger2xhiinBXM+HL+VfoIlLPvvK0/el4QfAs+H7kHUmCaVvEEt2PFypDJfGl7+oDyd/+lHWjXRsgRHFa1BgCUM9RSPERs8PvjRfTHeFGdqxkTeY2suUWRY3TOPy3nzfz9ndrr9l5X3LVWTQMJn3W9qsY0r0
 hqBPw2OO
 sQXo+pR/II7LgY5Hk7xt9WztbGyhuffXbJ4zbEi9Af/QkHAONP0xfWJwqdfgkdTyVbzHr8uS4RCMoZnVAC+kHTZnqYyeHRC6QJB1e8gvVrWPudXz30wI8uI/sNNVIOAxlZiIgyOudjRBPil95bBz/6t8n0iq2QSJqcz/aGiihb3GWMgMdYMdWniphg4cg9Rrv40kxgZcpjxLYMhEecnp7opu2yXjTbK32n1KRnJgRDUxlrjtFy8EJ8hoaQLnN2qwijVy5DwaUt+NtEHneHaDbCygaRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps file under the preps directory.  It will be evolved
to be used for generating sub directories that will represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 66a3e7de869a8..38affef08d0fb 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	int nr;
 };
 
 static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
@@ -763,12 +764,60 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_preps);
 }
 
+static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
+{
+	preps->nr = 0;
+}
+
+static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
+		int nr_preps)
+{
+	preps->nr = nr_preps;
+	return 0;
+}
+
+static ssize_t nr_preps_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_preps *preps = container_of(kobj,
+			struct damon_sysfs_preps, kobj);
+
+	return sysfs_emit(buf, "%d\n", preps->nr);
+}
+
+static ssize_t nr_preps_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_preps *preps;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	preps = container_of(kobj, struct damon_sysfs_preps, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_preps_add_dirs(preps, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_preps_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_preps_nr_attr =
+		__ATTR_RW_MODE(nr_preps, 0600);
+
 static struct attribute *damon_sysfs_preps_attrs[] = {
+	&damon_sysfs_preps_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_preps);
@@ -1150,8 +1199,10 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (probe->preps)
+	if (probe->preps) {
+		damon_sysfs_preps_rm_dirs(probe->preps);
 		kobject_put(&probe->preps->kobj);
+	}
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

