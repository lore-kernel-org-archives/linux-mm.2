Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48377606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 05:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e33bcLm1
Received: by kanga.kvack.org (Postfix)
	id E1AF16B05B1; Mon, 16 Nov 2026 00:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3146B05B2; Mon, 16 Nov 2026 00:26:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE50F6B05B3; Mon, 16 Nov 2026 00:26:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A62FC6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:26:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 235D7408D1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:26:26 +0000 (UTC)
X-FDA: 85439846772.14.EC5BF9F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 558C44000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:26:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e33bcLm1;
	spf=pass (imf27.hostedemail.com: domain of error27@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794806784;
	b=7b68XCMLO4f1YAYc8IeFfM4HQP2JZjQvO8aoMAk1j0AeqzSelE4VrEShdmWUSKxyklTrqV
	xBDUtKxL+9tju7TN7IHascdWl4xJQPDrmJMhNB2aAk1jNMCLQWrBapRDUWEQ6iIEruq9/k
	GNxifV0eZwAGdNHdWOm6WuKuONnc44M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e33bcLm1;
	spf=pass (imf27.hostedemail.com: domain of error27@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794806784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hz56qYSOSs9DQhsj5maa5eeVQHnnDEv1CGruA/BwN70=;
	b=BOHp5euTybaQiOzXQX0e9WeBN4whpRLEBFyNX0amsLiwb820pq7dwjk5CsCEaS7GHTOjQs
	ELMK3YvRNq+ZfFGmzSc9+LbpV6nRWSuE+8DfJEUvJL7oFcuz1I4ay+fuQPgkYvAr6/QMfu
	OvumeEujvwrVzQkbF7h6Y00Xyc30EYw=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e09aa5264so1348800f8f.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794806783; x=1795411583; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hz56qYSOSs9DQhsj5maa5eeVQHnnDEv1CGruA/BwN70=;
        b=e33bcLm1OBhb0r7qH2ivlrlwcrdKVDXdJm2twGFeYDIhLqjBpAFiYfOjtvN9AX56yh
         9NgAgXWtKX4IBvuyboszVlXJvfzUMoeFBj+Kl9VplzRfIgFdprShD1eyQcAmD3Ntyn2Q
         45euAWud9So22xP5hpA7teJEU++DMcjyMG77RIpyRlhbi1Qm256Ef9g+wsQPCytOu4ji
         hv5kx+tUIaNBT+Jw76RonTflempNXsBpDRO0KlOtnOcKPl8xvDwI0UwkZFnx2H6zwwVv
         PdbcGYLdgzkHKgCjKJLvU3I9E6MoaqY/4tHrDp5NYUP0TST9TNXFDGG41yEheJ7r5czN
         ai4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794806783; x=1795411583;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hz56qYSOSs9DQhsj5maa5eeVQHnnDEv1CGruA/BwN70=;
        b=OQkU72HIN5rLfcIYbqAsZmI0GwW9tCZ4sF5ehbZvfJvSRR24d6w1aQgE6dYsBSMyD8
         5GjyS20xugm6kJQKbSj8q4LtOyx1eenbLEPdgQkPB/Gv2YZDkoUROZV3D9M3X5PHiAKE
         6XtYDjI440styJHGzlsVLlJo6Bu9jCPEOJu8QJFiyHMzCNftqg+zKKvmDOH4tolJS5F3
         vIImCy5/Krd3QUCRbei6hbQedtDMk06GMkdVNyZPO10Cjo6mpxKXoiHSah/g3IOeuZW+
         7uzyZwJU5eR+be9pmN9oHUyl+z2Z2JEg7wrmIrJeVTFLY6eRSHMVVc1o+5RutfGG/pUQ
         4dQw==
X-Forwarded-Encrypted: i=1; AL+hErGNptU/Zdw6a6EUbAoCqUxs+zzD8rK2UIzRFOO5SxSQdyJiAOeY3NpA5M0auB2f+i5aciy7YRsyKw==@kvack.org
X-Gm-Message-State: APuU4Z/Gcy/0ope6iMWcedOn7/OMupQkWIJlQ5VPKYdCHGe4K989KEsa
	dxkLeCbnSa6CEVXZk97FaQnPIQBQehruiZYN8vcTdIZZoA3MiQ8QuXeM
X-Gm-Gg: AYBFou1x0JgY5vbO0/YG7jhW0brOEkxUMPiPFSQVQ7vTnk4QIkMSEkggCGdBqm+oT9U
	rQ8nAkpEMrguo29gxSWsU0CnLbQdZL5CvnUEaUrmQw+KYnkU3UW050Ta4ykmoZ9wk489zSo5zt2
	7a3mdNaFHfrtQksXZ0knHmPoqL3k8Maj8U5nMJDMc2aLCl7JVcOwEBjfAGeMVhlTDq3DI6iTNgJ
	VGBdGgAxO+4/Fxsxr3eoorygxgqG1yaJYBp0oh/AWLcUuX/6O6czd7gs9u73eDYFjlPOdAa2k3F
	jj0w9sTm0pijwXCVJGnsU3dbYZ0uG8QVHNAeDt3W9D421eFjYXCOdJ2FSReCQs/XR+3Uo1IDmKV
	czftVTzxS4kBcWnOatZJZCNam7071zKkZWW01cjUqhBBG/Ph3tdeh6ZdYvz9Te+aGw0KT7//H3Q
	GiiMvGzkjowqtWjXgdHpPluRDAQoVvpkQEUO/XqWzoP62jOA9mb74I0Xry8TvyhZe3sO3jMVl8B
	zwNOiB2DL+CJEm1XgUUvjogisor9MsP36axWOXflq7SfP0l+ilIUsy3rgsI+radABXDB99faI3F
	xekYSA/dHm20pvS6YWDdiDf6Z2eqSU/dD4Ox+7USWfoPpgss5L/z0hFxfJQowMGun2g0PT6lTNU
	epXQpQJ8ngHiij86aH5NGua9tufd0hJruwOzh4/PCTFN3iwSloSx7GM3+vRpxwzuPp0A=
X-Received: by 2002:a05:6000:26c8:b0:491:8462:20cc with SMTP id ffacd0b85a97d-49c73ce5e65mr21515228f8f.37.1794806782617;
        Sun, 15 Nov 2026 21:26:22 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60da0a03sm16137617f8f.53.2026.11.15.21.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 21:26:22 -0800 (PST)
Date: Mon, 16 Nov 2026 08:26:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: oe-kbuild@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 139/151] fs/squashfs/namei.c:283
 squashfs_lookup() warn: passing zero to 'ERR_PTR'
Message-ID: <202611131955.0Gd7ipSP-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 7pharhbtc4bxizfs59bra6nixjhi7pmp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 558C44000A
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794806784-264481
X-HE-Meta: U2FsdGVkX1+2RV3sfcPw7m0A8ZkO9w9WAl7WaJhDW2SXLOf+ni46uj97x6EbLH2YeSIfpJR1kPoWk5/kHwftSMEtsnAQfdZ0XsY1+9q/3I3CNQ7bAIaCMI55w8rzB5AENx7FLmULezDGndWhMhEGkH8VuwEaIutDs22plwB1V9sbnnB/HhKDpVBHorkX2S9RJsUUfBiVlrMRX6CupvE62t9PFiQk61Y8Im5fZcWcHMCOqk83E01rcd5DCTkF9YkbH3PNmB+TWM4UX2kOtmIYG2r3ShOVpGzYgdobXPyustGaSJHkmmD3dL9Vt1lTGCV+z5H27eJh/Aruo3VIXYLGT6ewdyy7QFPNCeZ8rByI9rD/0UWlDD3mYASSFy8RBoLIYkQlLanpoIL2UIaLfsix29A0uzNvW7aIDlOQp72mH54a4qqw/uFB4KDGuGEsmXrSb7DnfiXrOkXomhHKdQjrYumyj2xWzfT8JjIQ4somouVPY9Sq9wpNUGbfvNNaz3vV18HmerltHYKjkAJQN9i9YIlNx9IBEitIF2l0eDWl+0UhiA62xj87GXZdhooE+/9h0l31Fza+ISthFo/x1uQHZg6K14tQr3ebypIWaD8HZvkKDESHcHu1Kst1hY6dducI9J8+3Bc5ex3+wWJT4B5vH2b/0OOW6mTuqM0783396xVkXXaGybNlUlo41J/fJ8GstYu1Ld0jBD48mhPJx8I0/WVy3gqyGh8g+RMyJmpakYFNDLsaBwLfF1F5DvHc6gY0RjxSVjK4VnVevmHr+G7lwu/8iJO5c2JORFL1DpXMVRq/4J0C7OttCbNg6InqpJMsad4DV9khp4oIpz/XgJZPdiKvYVOhCDP5/xix7q+M9izb0qgOFiUP2fY44WPipZ/TaF1NiabVSo9UTMJm659GFyUz3FgObxdRT1D0UGtCVMCoGW1PsNkebaMdsG2UBohSvLO+sDnlGJT7/8zxPz6
 9v0QYG/X
 jul31V9ymafZ/lJGRB1hHDxZkMlHlh/vbG5eEzzWDIbQJ1DzSdFuiX7f9Q3Fpnkx7FeBPLqbIr0uLAAgMCGInhR60HVlX0bi2sxagyxilVhhYM1xy5b+kjcoShEYIuyDfM4SolLjV0t32980Kp4AkyMTN/m80wAEqwl7YEAUieX+Fz1cps80v79slzjSnvQdHO4dm7jK55+VSyO9KXF6jpiyKjO6K8VS140W+eTim7WMHGQP4EyrjvKbxGevvnLN/rU2vB9BDjcH975npM7MI9QdJojLrW8n6kU/ZNbcz1PPz/lOI/+zeKyreyG0YjYmOtTJzf2XFX14+JJFMoxc6QB1Jr+KuCQXDCmYmgQWNxrprth/Rjg1H3kMkFW6iENYDGrs3Zhi8YlQ8r93h5GcWv1Hs0/T+IucA+AlPFTid86Iis7M10FjmxTtEFHyvd3oZsYTQIV9lzpugTqS/obVvDnApMjO6EAdBfH7wDNiDtryfV9hbv+NXPPQjiBmNiLIRdH3nklZRl3EoJYZC2XSYpKZMljqdSE91brU/Pe4hJCQBUoAWLN+ySFRf6oX/RKor2oYVIU48kq5NdX9OjsGLzmVfuLOFy6GmZ1m+ZhWtRDuas5xE6WPICIGkFkqN99auATgScLpbzcvmoBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   152f0559e66c079f717de375f133ff127afb1f58
commit: 5213b0a08263b2191b86b046c3a63f11e8abc399 [139/151] Squashfs: fix variables in directory code and add more sanity checks
config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131955.0Gd7ipSP-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/

New smatch warnings:
fs/squashfs/namei.c:283 squashfs_lookup() warn: passing zero to 'ERR_PTR'

vim +/ERR_PTR +283 fs/squashfs/namei.c

c88da2c979369e6 Phillip Lougher 2009-01-05  164  static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
00cd8dd3bf95f2c Al Viro         2012-06-10  165  				 unsigned int flags)
c88da2c979369e6 Phillip Lougher 2009-01-05  166  {
c88da2c979369e6 Phillip Lougher 2009-01-05  167  	const unsigned char *name = dentry->d_name.name;
c88da2c979369e6 Phillip Lougher 2009-01-05  168  	int len = dentry->d_name.len;
c88da2c979369e6 Phillip Lougher 2009-01-05  169  	struct inode *inode = NULL;
c88da2c979369e6 Phillip Lougher 2009-01-05  170  	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
c88da2c979369e6 Phillip Lougher 2009-01-05  171  	struct squashfs_dir_header dirh;
4dddf794b08bef0 Phillip Lougher 2026-11-11  172  	struct squashfs_dir_entry *dire = NULL;
4dddf794b08bef0 Phillip Lougher 2026-11-11  173  	u64 block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
c88da2c979369e6 Phillip Lougher 2009-01-05  174  	int offset = squashfs_i(dir)->offset;
5213b0a08263b21 Phillip Lougher 2026-11-11  175  	int err;
5213b0a08263b21 Phillip Lougher 2026-11-11  176  	loff_t length;
52e9ce1c0f20606 Phillip Lougher 2013-09-03  177  	unsigned int dir_count, size;
c88da2c979369e6 Phillip Lougher 2009-01-05  178  
4dddf794b08bef0 Phillip Lougher 2026-11-11  179  	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
4dddf794b08bef0 Phillip Lougher 2026-11-11  180  
4dddf794b08bef0 Phillip Lougher 2026-11-11  181  	if (block < 0)
4dddf794b08bef0 Phillip Lougher 2026-11-11  182  		goto data_error;
c88da2c979369e6 Phillip Lougher 2009-01-05  183  
c88da2c979369e6 Phillip Lougher 2009-01-05  184  	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
c88da2c979369e6 Phillip Lougher 2009-01-05  185  	if (dire == NULL) {
c88da2c979369e6 Phillip Lougher 2009-01-05  186  		ERROR("Failed to allocate squashfs_dir_entry\n");
c88da2c979369e6 Phillip Lougher 2009-01-05  187  		return ERR_PTR(-ENOMEM);
c88da2c979369e6 Phillip Lougher 2009-01-05  188  	}
c88da2c979369e6 Phillip Lougher 2009-01-05  189  
c88da2c979369e6 Phillip Lougher 2009-01-05  190  	if (len > SQUASHFS_NAME_LEN) {
c88da2c979369e6 Phillip Lougher 2009-01-05  191  		err = -ENAMETOOLONG;
c88da2c979369e6 Phillip Lougher 2009-01-05  192  		goto failed;
c88da2c979369e6 Phillip Lougher 2009-01-05  193  	}
c88da2c979369e6 Phillip Lougher 2009-01-05  194  
c88da2c979369e6 Phillip Lougher 2009-01-05  195  	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
c88da2c979369e6 Phillip Lougher 2009-01-05  196  				squashfs_i(dir)->dir_idx_start,
c88da2c979369e6 Phillip Lougher 2009-01-05  197  				squashfs_i(dir)->dir_idx_offset,
5213b0a08263b21 Phillip Lougher 2026-11-11  198  				squashfs_i(dir)->dir_idx_cnt,
5213b0a08263b21 Phillip Lougher 2026-11-11  199  				i_size_read(dir), name);
c88da2c979369e6 Phillip Lougher 2009-01-05  200  
c88da2c979369e6 Phillip Lougher 2009-01-05  201  	while (length < i_size_read(dir)) {
c88da2c979369e6 Phillip Lougher 2009-01-05  202  		/*
c88da2c979369e6 Phillip Lougher 2009-01-05  203  		 * Read directory header.
c88da2c979369e6 Phillip Lougher 2009-01-05  204  		 */
5213b0a08263b21 Phillip Lougher 2026-11-11  205  		if (!squashfs_dir_space(dir, length, sizeof(dirh)))
5213b0a08263b21 Phillip Lougher 2026-11-11  206  			goto read_failure;
5213b0a08263b21 Phillip Lougher 2026-11-11  207  
c88da2c979369e6 Phillip Lougher 2009-01-05  208  		err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
c88da2c979369e6 Phillip Lougher 2009-01-05  209  				&offset, sizeof(dirh));
c88da2c979369e6 Phillip Lougher 2009-01-05  210  		if (err < 0)
c88da2c979369e6 Phillip Lougher 2009-01-05  211  			goto read_failure;
c88da2c979369e6 Phillip Lougher 2009-01-05  212  
c88da2c979369e6 Phillip Lougher 2009-01-05  213  		length += sizeof(dirh);
c88da2c979369e6 Phillip Lougher 2009-01-05  214  
c88da2c979369e6 Phillip Lougher 2009-01-05  215  		dir_count = le32_to_cpu(dirh.count) + 1;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  216  
4826d83d9c4f6bb Ajeet Yadav     2012-02-02  217  		if (dir_count > SQUASHFS_DIR_COUNT)
44cff8a9ee8a974 Phillip Lougher 2011-03-15  218  			goto data_error;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  219  
c88da2c979369e6 Phillip Lougher 2009-01-05  220  		while (dir_count--) {
c88da2c979369e6 Phillip Lougher 2009-01-05  221  			/*
c88da2c979369e6 Phillip Lougher 2009-01-05  222  			 * Read directory entry.
c88da2c979369e6 Phillip Lougher 2009-01-05  223  			 */
5213b0a08263b21 Phillip Lougher 2026-11-11  224  			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
5213b0a08263b21 Phillip Lougher 2026-11-11  225  				goto read_failure;

We need an error code on this path.

5213b0a08263b21 Phillip Lougher 2026-11-11  226  
c88da2c979369e6 Phillip Lougher 2009-01-05  227  			err = squashfs_read_metadata(dir->i_sb, dire, &block,
c88da2c979369e6 Phillip Lougher 2009-01-05  228  					&offset, sizeof(*dire));
c88da2c979369e6 Phillip Lougher 2009-01-05  229  			if (err < 0)
c88da2c979369e6 Phillip Lougher 2009-01-05  230  				goto read_failure;
c88da2c979369e6 Phillip Lougher 2009-01-05  231  
5213b0a08263b21 Phillip Lougher 2026-11-11  232  			length += sizeof(*dire);
c88da2c979369e6 Phillip Lougher 2009-01-05  233  			size = le16_to_cpu(dire->size) + 1;
c88da2c979369e6 Phillip Lougher 2009-01-05  234  
44cff8a9ee8a974 Phillip Lougher 2011-03-15  235  			/* size should never be larger than SQUASHFS_NAME_LEN */
44cff8a9ee8a974 Phillip Lougher 2011-03-15  236  			if (size > SQUASHFS_NAME_LEN)
44cff8a9ee8a974 Phillip Lougher 2011-03-15  237  				goto data_error;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  238  
5213b0a08263b21 Phillip Lougher 2026-11-11  239  			if (!squashfs_dir_space(dir, length, size))
5213b0a08263b21 Phillip Lougher 2026-11-11  240  				goto read_failure;

And here.

5213b0a08263b21 Phillip Lougher 2026-11-11  241  
c88da2c979369e6 Phillip Lougher 2009-01-05  242  			err = squashfs_read_metadata(dir->i_sb, dire->name,
c88da2c979369e6 Phillip Lougher 2009-01-05  243  					&block, &offset, size);
c88da2c979369e6 Phillip Lougher 2009-01-05  244  			if (err < 0)
c88da2c979369e6 Phillip Lougher 2009-01-05  245  				goto read_failure;
c88da2c979369e6 Phillip Lougher 2009-01-05  246  
5213b0a08263b21 Phillip Lougher 2026-11-11  247  			length += size;
c88da2c979369e6 Phillip Lougher 2009-01-05  248  
c88da2c979369e6 Phillip Lougher 2009-01-05  249  			if (name[0] < dire->name[0])
c88da2c979369e6 Phillip Lougher 2009-01-05  250  				goto exit_lookup;
c88da2c979369e6 Phillip Lougher 2009-01-05  251  
c88da2c979369e6 Phillip Lougher 2009-01-05  252  			if (len == size && !strncmp(name, dire->name, len)) {
c88da2c979369e6 Phillip Lougher 2009-01-05  253  				unsigned int blk, off, ino_num;
c88da2c979369e6 Phillip Lougher 2009-01-05  254  				long long ino;
c88da2c979369e6 Phillip Lougher 2009-01-05  255  				blk = le32_to_cpu(dirh.start_block);
c88da2c979369e6 Phillip Lougher 2009-01-05  256  				off = le16_to_cpu(dire->offset);
c88da2c979369e6 Phillip Lougher 2009-01-05  257  				ino_num = le32_to_cpu(dirh.inode_number) +
c88da2c979369e6 Phillip Lougher 2009-01-05  258  					(short) le16_to_cpu(dire->inode_number);
cec4a69189091ba Phillip Lougher 2026-11-11  259  				ino = squashfs_mkinode(blk, off);
c88da2c979369e6 Phillip Lougher 2009-01-05  260  
c88da2c979369e6 Phillip Lougher 2009-01-05  261  				TRACE("calling squashfs_iget for directory "
c88da2c979369e6 Phillip Lougher 2009-01-05  262  					"entry %s, inode  %x:%x, %d\n", name,
c88da2c979369e6 Phillip Lougher 2009-01-05  263  					blk, off, ino_num);
c88da2c979369e6 Phillip Lougher 2009-01-05  264  
c88da2c979369e6 Phillip Lougher 2009-01-05  265  				inode = squashfs_iget(dir->i_sb, ino, ino_num);
c88da2c979369e6 Phillip Lougher 2009-01-05  266  				goto exit_lookup;
c88da2c979369e6 Phillip Lougher 2009-01-05  267  			}
c88da2c979369e6 Phillip Lougher 2009-01-05  268  		}
c88da2c979369e6 Phillip Lougher 2009-01-05  269  	}
c88da2c979369e6 Phillip Lougher 2009-01-05  270  
c88da2c979369e6 Phillip Lougher 2009-01-05  271  exit_lookup:
c88da2c979369e6 Phillip Lougher 2009-01-05  272  	kfree(dire);
c88da2c979369e6 Phillip Lougher 2009-01-05  273  	return d_splice_alias(inode, dentry);
c88da2c979369e6 Phillip Lougher 2009-01-05  274  
44cff8a9ee8a974 Phillip Lougher 2011-03-15  275  data_error:
44cff8a9ee8a974 Phillip Lougher 2011-03-15  276  	err = -EIO;
44cff8a9ee8a974 Phillip Lougher 2011-03-15  277  
c88da2c979369e6 Phillip Lougher 2009-01-05  278  read_failure:
c88da2c979369e6 Phillip Lougher 2009-01-05  279  	ERROR("Unable to read directory block [%llx:%x]\n",
4dddf794b08bef0 Phillip Lougher 2026-11-11  280  		squashfs_i(dir)->start, squashfs_i(dir)->offset);
c88da2c979369e6 Phillip Lougher 2009-01-05  281  failed:
c88da2c979369e6 Phillip Lougher 2009-01-05  282  	kfree(dire);
c88da2c979369e6 Phillip Lougher 2009-01-05 @283  	return ERR_PTR(err);
c88da2c979369e6 Phillip Lougher 2009-01-05  284  }

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


