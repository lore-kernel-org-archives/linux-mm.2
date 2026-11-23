Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAD5606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNxcIodY
Received: by kanga.kvack.org (Postfix)
	id 43F676B05C3; Mon, 23 Nov 2026 09:06:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0A66B05C4; Mon, 23 Nov 2026 09:06:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF106B05C7; Mon, 23 Nov 2026 09:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEDA26B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:06:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 598568088C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:06:06 +0000 (UTC)
X-FDA: 85466557932.04.65FB217
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 91A4640019
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:06:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNxcIodY;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795442764;
	b=SByye920bkfSF9YSDc3PVXEA8oV7C954yd9JnME5/EQujoAN5ZlMx4J1ZhVQTLIIwBowWq
	oYVACHOWgAQC6JEdXoQubSUpPq804AD8XR6wByfWjYZqd60ImoVYrajHYwTRyqZM01FLPX
	a/ITxrVdyq5q8opXdqibaUFpd6ovtQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795442764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhrfZY0fbfvRqh4m81PmC72i9FRlptZs7yDrySCwPr4=;
	b=lTYRCVGhjSjxxDksbEFvlBFkFt2sqb3ypydGCkuOh0bulNxXQa96Sl4JjRaJssPqAPQf9e
	dS0i8nDmkN8tAT/w7qX4O5QB71F9kQbDMcwVNPLpPFQpbixa3KqOATfnVUftXH9T1mCKNf
	n/OT2sU+ox2DfQ+DhTlBokbYJxi0DW4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNxcIodY;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D5929621AD;
	Mon, 23 Nov 2026 14:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D36961F000CF;
	Mon, 23 Nov 2026 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795442762;
	bh=ZhrfZY0fbfvRqh4m81PmC72i9FRlptZs7yDrySCwPr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RNxcIodYicyykOWzJV9ac41R/wLtMtTMT0f/m7QOJ6ld+W2V4NCjmrvht5+ezWSqk
	 Dy3cclszSYRA92VabFyR/cC0uPGOyYPHssIDBCdfY+KgqULwwUey6pUnHB73Wz2LlR
	 hkvMBoXjf7CrpiBPOawkWFvKWPg3qpI0I0BA69XEEhog6RMMjCMYfTFgbRasThroj3
	 3VZZgT2wtToaSR3IXgQGEzMZxs3Ms6FWViRaFd9Loduz7vVzijOuh6nSFxj66HY9ck
	 NEhojYrvdZmhi6MyoIHwjX3SFqytTuELhGvYjoQLWNYl5Hp0HF12MLor0raNKqJDPd
	 nl02fB8BrjaLw==
Date: Mon, 23 Nov 2026 16:05:58 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	aleksa@amutable.com, alex@amutable.com, viro@zeniv.linux.org.uk,
	luto@amacapital.net, arnd@arndb.de, brauner@kernel.org,
	dhowells@redhat.com, ebiggers@kernel.org, giuseppe@scrivano.org,
	hughd@google.com, jack@suse.cz, jlayton@kernel.org, corbet@lwn.net,
	josef@toxicpanda.com, kees@kernel.org, kpsingh@kernel.org,
	lennart@poettering.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, zygmunt.krynicki@canonical.com,
	ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
	martin.lau@kernel.org, eddyz87@gmail.com, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [RFC PATCH v7 07/26] mount: Support MOVE_MOUNT_CLONE with
 MOVE_MOUNT_T_MNTNS
Message-ID: <awRIRrGwOi97H15D@kernel.org>
References: <20261122193539.3334213-8-jarkko@kernel.org>
 <cac1fa0b133e15e7c67629319df17a0d25747093535aa246f44a75cb1073e2ed@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac1fa0b133e15e7c67629319df17a0d25747093535aa246f44a75cb1073e2ed@mail.kernel.org>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 91A4640019
X-Stat-Signature: u39izfaw86cnxmg8sbux7if4sroyynnf
X-Rspam-User:
X-HE-Tag: 1795442764-131379
X-HE-Meta: U2FsdGVkX1/IKuzHjMBq5imUwoE0tjTJew2p8w/VIbBGxOzm3pEYp0+40S/W97SHeE70crG+Tx/T4f3GC00MEqbQnPy/TplX0dyATqcB2a0743yEA6hywMr4Od8dXzd0WbUEzlSnck0ADTvnP6aRMPrTAuo2FDY2WPjc5i+oZHZ7DuhppJWN6m34/2PF9TUo03/wOJn3ZmsUpNTbTcKhbNcrEHDuYk8JDSGHUUL/IAGaOQ7+v4xJeHto4TqkTkXwrG0/UBvN4qUJOdiopgC1y1AjCtWzzMB04K5w9fXIavq9TsA8t/Z7w1xzJOV+Xb5ocmm7lSXh6wLM5z73r/EfNn8zKIRqqOyWRMSo0bekYemyK0wFS0WSGuOEpga2cwVLC7Ca7ugBmuX4iXdHe9Lss/Mp6GGzqUcfno7keJ/VgYMnvHK6W2Sea4H6D8VuTokxXZjl4BLfgEOM37w/HAUI06A2lJg6AoYiXyYcfzEWSN8qkWgZFKp1ZoVEbKU8Hh6rb8fYaR3osI5b2b4pG6lM3+fFz+er5qIn1tAQSPORX+oDxtNyCG3guDf/5hQktOs3BKIQG9l3uNrpV4I0PZTOsuCvVEnzOr80QRi8SLcatOYynPveTe/NZAyfRMM75Hz+M3QKeNyEgHKAGZRwNHFBxCTGZJ6doU2kuRMImQx3sDC/h/tqY+GfXgKpkvsTVClXxATd3dtIC6mU+9F0nGbklE8gyqfPkvYr/k/+KTcH5PYJL7usItiAdxYrK1KcJuMhKCj0MKGdGbO6jwOu1TfvVjsPrI/r9w7syhQGxOexAGuDHWRqiOGU6q1NRU5uH4Izywt567lywJfTmNQV8T93ljWGM73QjhQMrCt85jfhlQU3fQArsDqjXLV1JMPTA9G7Px/9lEMGCmphmkhkwDs0pw773bN/DTexkhcqWAPoBMSmq+/xqoAAy1VqATcQZCJX91m4IWAguOrnqjbZEt5
 1xF3Ld47
 u0v0OEPpXKK4E0UcIKndq2ZMeJEZBAONGPpgcthJfs4cit/cEH9M7bxWoOq+s39rPIRwHQ9nG6oNqE9s4gwUq/vhHnU0CkSJnHwHgnJTgIHc67kluyhE6a4wFbh1iIHg/G9LgYJTfLo5SjQg1BLuvnK+LJn3brj6fCXB5S9l+RBEzyF/sbDmvnyLpE5LOcHIbUtBrqhySWPjX2p8TXPkZq9Utpc/JdAW9hvRmHm+iNvRvYP3BRSq8MKwDkw0QU/rM1GickPItq1Gxsuc4ohGD5+8Nq6QwQf6ZqZuAtKjjZLTPjMHgMDwCGvQnPYWyTVL7z4OMQtP+ZKmYyD7CyZV+5R0QpoLIYEEm9E7Ca+ksUTycH/PggrwhSaikx8+qx5mQAlA/b06IBpnTjd6o64LsisIJLgxPY1p5l3LRvVXLTrmSAcpkcRGi+af4Ct4m7gP0Q97RfHGb4xeK5zt8Xsoy+xhRFqkHgHWPPKnlyNwyBzjnrO/+EGFOZk+lNpIOyq7VapGQS+N1K6MJ9/6aR3hbJS464WgzuCxj+nvIJYRDNwP9EgtzCKAFEif5BQlE78+LoMKOvxBS163gpkBpi9bbqTyJbDcLB0l46w/B8pJ6qI9e7oP5+JrehHN6gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 08:28:11PM +0000, bot+bpf-ci@kernel.org wrote:
> Should the clone be reported to LSMs as a bind, for example through a
> separate hook, a flag passed to security_move_mount(), or a call to the
> bind-mount mediation?

Mediation can be trivially achieved:

diff --git a/security/apparmor/include/mount.h b/security/apparmor/include/mount.h
index 46834f828179..d771ee240d42 100644
--- a/security/apparmor/include/mount.h
+++ b/security/apparmor/include/mount.h
@@ -43,7 +43,7 @@ int aa_move_mount_old(const struct cred *subj_cred,
                      const char *old_name);
 int aa_move_mount(const struct cred *subj_cred,
                  struct aa_label *label, const struct path *from_path,
-                 const struct path *to_path);
+                 const struct path *to_path, unsigned int flags);

 int aa_new_mount(const struct cred *subj_cred,
                 struct aa_label *label, const char *dev_name,
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index aefa71bc1cd2..797944de8273 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -751,7 +751,7 @@ static int apparmor_move_mount(const struct path *from_path,
        label = __begin_current_label_crit_section(&needput);
        if (!unconfined(label))
                error = aa_move_mount(current_cred(), label, from_path,
-                                     to_path);
+                                     to_path, flags);
        __end_current_label_crit_section(label, needput);

        return error;
diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 4ed7b9136beb..8d3db6bfdfb6 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -423,13 +423,15 @@ int aa_mount_change_type(const struct cred *subj_cred,

 int aa_move_mount(const struct cred *subj_cred,
                  struct aa_label *label, const struct path *from_path,
-                 const struct path *to_path)
+                 const struct path *to_path, unsigned int flags)
 {
        struct aa_profile *profile;
        char *to_buffer = NULL, *from_buffer = NULL;
+       unsigned long mnt_flags = (flags & MOVE_MOUNT_CLONE) ?
+                                 (MS_BIND | MS_REC) : MS_MOVE;
        int error;
        DEFINE_AUDIT_MOUNT(ad, OP_MOUNT, subj_cred);
-       ad.mnt.flags = MS_MOVE;
+       ad.mnt.flags = mnt_flags;

        AA_BUG(!label);
        AA_BUG(!from_path);
@@ -441,12 +443,12 @@ int aa_move_mount(const struct cred *subj_cred,
        if (!to_buffer || !from_buffer)
                goto out;

-       if (!our_mnt(from_path->mnt))
+       if (!(flags & MOVE_MOUNT_CLONE) && !our_mnt(from_path->mnt))
                /* moving a mount detached from the namespace */
                from_path = NULL;
        error = fn_for_each(label, profile,
                        match_mnt(profile, to_path, to_buffer, from_path,
-                                 from_buffer, NULL, MS_MOVE, NULL, false,
+                                 from_buffer, NULL, mnt_flags, NULL, false,
                                  &ad));
 out:
        aa_put_buffer(to_buffer);
@@ -467,7 +469,7 @@ int aa_move_mount_old(const struct cred *subj_cred, struct aa_label *label,
        if (error)
                return error;

-       error = aa_move_mount(subj_cred, label, &old_path, path);
+       error = aa_move_mount(subj_cred, label, &old_path, path, 0);
        path_put(&old_path);

        return error;

Br, Jarkko

